module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    attr_accessor :message

    def initialize(message)
      @message = message
      Rails.logger.info "ContactPushNotificationService: Initialized with message #{message&.id}"
    end

    def perform
      Rails.logger.info "ContactPushNotificationService: Starting push notification for message #{message&.id}"

      # Validate message exists
      unless message.present?
        Rails.logger.error 'ContactPushNotificationService: No message provided'
        return false
      end

      # Check if we should send push
      unless should_send_push?
        Rails.logger.info 'ContactPushNotificationService: Skipping push - conditions not met'
        return false
      end

      # Check if contact has push token
      unless contact&.push_token.present?
        Rails.logger.info "ContactPushNotificationService: Skipping push - no push token for contact #{contact&.id}"
        return false
      end

      Rails.logger.info "ContactPushNotificationService: Sending push to contact #{contact.id} with token #{mask_token(contact.push_token)}"

      # Determine which push service to use
      if chatwoot_hub_enabled?
        Rails.logger.info 'ContactPushNotificationService: Using Chatwoot Hub for push delivery'
        send_push_via_chatwoot_hub
      elsif firebase_credentials_present?
        Rails.logger.info 'ContactPushNotificationService: Using Firebase FCM for push delivery'
        send_fcm_push
      else
        Rails.logger.error 'ContactPushNotificationService: No push configuration found - neither Chatwoot Hub nor Firebase configured'
        return false
      end

      true
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: Unexpected error: #{e.message}"
      Rails.logger.error "ContactPushNotificationService: Backtrace: #{e.backtrace.join("\n")}"
      raise e
    end

    private

    def contact
      @contact ||= message&.conversation&.contact.tap do |c|
        if c.present?
          Rails.logger.info "ContactPushNotificationService: Found contact #{c.id}"
          if c.push_token.present?
            Rails.logger.info "ContactPushNotificationService: Contact has push token: #{mask_token(c.push_token)}"
          else
            Rails.logger.info 'ContactPushNotificationService: Contact has no push token'
          end
        else
          Rails.logger.info 'ContactPushNotificationService: No contact found for message'
        end
      end
    end

    def conversation
      @conversation ||= message&.conversation.tap do |conv|
        if conv.present?
          Rails.logger.info "ContactPushNotificationService: Found conversation #{conv.id}"
        else
          Rails.logger.error 'ContactPushNotificationService: No conversation found for message'
        end
      end
    end

    def account
      @account ||= conversation&.account.tap do |acc|
        if acc.present?
          Rails.logger.info "ContactPushNotificationService: Found account #{acc.id}"
        else
          Rails.logger.error 'ContactPushNotificationService: No account found for conversation'
        end
      end
    end

    def should_send_push?
      Rails.logger.info 'ContactPushNotificationService: Checking if push should be sent...'

      unless message&.outgoing?
        Rails.logger.info "ContactPushNotificationService: Message is not outgoing (incoming: #{!message&.outgoing?})"
        return false
      end

      if message.private?
        Rails.logger.info 'ContactPushNotificationService: Message is private'
        return false
      end

      unless contact.present?
        Rails.logger.info 'ContactPushNotificationService: No contact found'
        return false
      end

      # Additional checks you might want to add
      unless conversation.present?
        Rails.logger.info 'ContactPushNotificationService: No conversation found'
        return false
      end

      unless account.present?
        Rails.logger.info 'ContactPushNotificationService: No account found'
        return false
      end

      Rails.logger.info 'ContactPushNotificationService: All conditions met for sending push'
      true
    end

    def sender_name
      name = message&.sender&.name || account&.name || 'Support'
      Rails.logger.info "ContactPushNotificationService: Using sender name: #{name}"
      name
    end

    def push_message_title
      sender_name
    end

    def push_message_body
      return '' unless message&.content.present?

      body = message.content.truncate(100)
      Rails.logger.info "ContactPushNotificationService: Push body: #{body[0..50]}#{'...' if body.length > 50}"
      body
    end

    def send_fcm_push
      Rails.logger.info 'ContactPushNotificationService: Initializing FCM service'

      project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)
      credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)

      Rails.logger.info "ContactPushNotificationService: Firebase project ID present: #{project_id.present?}"
      Rails.logger.info "ContactPushNotificationService: Firebase credentials present: #{credentials.present?}"

      fcm_service = Notification::FcmService.new(project_id, credentials)
      fcm = fcm_service.fcm_client

      Rails.logger.info "ContactPushNotificationService: Sending FCM notification with options: #{fcm_options.except(:token)}"

      response = fcm.send_v1(fcm_options)
      handle_fcm_response(response)
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: FCM Error: #{e.message}"
      Rails.logger.error "ContactPushNotificationService: FCM Backtrace: #{e.backtrace.join("\n")}"
      raise e
    end

    def handle_fcm_response(response)
      Rails.logger.info "ContactPushNotificationService: FCM Response status: #{response[:status_code]}"
      Rails.logger.info "ContactPushNotificationService: FCM Response body: #{response[:body]}" if response[:body]

      case response[:status_code]
      when 200
        Rails.logger.info 'ContactPushNotificationService: FCM push sent successfully'
        return true
      when 400
        Rails.logger.error 'ContactPushNotificationService: FCM Bad Request - Invalid request format or token'
        # Consider marking token as invalid
        mark_token_as_invalid('Bad request from FCM')
      when 401
        Rails.logger.error 'ContactPushNotificationService: FCM Authentication failed - Check Firebase credentials'
      when 404
        Rails.logger.error 'ContactPushNotificationService: FCM Token not found - Token may be invalid or expired'
        mark_token_as_invalid('Token not found')
      when 429
        Rails.logger.error 'ContactPushNotificationService: FCM Rate limited - Too many requests'
      when 500..599
        Rails.logger.error 'ContactPushNotificationService: FCM Server error - Retry later'
      else
        Rails.logger.error "ContactPushNotificationService: FCM Unexpected status code: #{response[:status_code]}"
      end

      false
    end

    def send_push_via_chatwoot_hub
      Rails.logger.info 'ContactPushNotificationService: Sending push via Chatwoot Hub'
      Rails.logger.info "ContactPushNotificationService: Hub payload: #{fcm_options.except(:token)}"

      begin
        result = ChatwootHub.send_push(fcm_options)
        Rails.logger.info "ContactPushNotificationService: Chatwoot Hub response: #{result.inspect}"

        if result.is_a?(Hash) && result[:error]
          Rails.logger.error "ContactPushNotificationService: Chatwoot Hub error: #{result[:error]}"
          return false
        end

        Rails.logger.info 'ContactPushNotificationService: Push sent successfully via Chatwoot Hub'
        true
      rescue StandardError => e
        Rails.logger.error "ContactPushNotificationService: Chatwoot Hub error: #{e.message}"
        Rails.logger.error "ContactPushNotificationService: Chatwoot Hub backtrace: #{e.backtrace.join("\n")}"
        raise e
      end
    end

    def firebase_credentials_present?
      project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)
      credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)

      present = project_id.present? && credentials.present?
      Rails.logger.info "ContactPushNotificationService: Firebase credentials check - Project ID: #{project_id.present?}, Credentials: #{credentials.present?}, Overall: #{present}"
      present
    end

    def chatwoot_hub_enabled?
      enabled = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PUSH_RELAY_SERVER', true))
      Rails.logger.info "ContactPushNotificationService: Chatwoot Hub enabled: #{enabled}"
      enabled
    end

    def fcm_options
      options = {
        'token': contact.push_token,
        'data': fcm_data,
        'notification': fcm_notification,
        'android': fcm_android_options,
        'apns': fcm_apns_options
      }

      # Log options without exposing the token
      safe_options = options.deep_dup
      safe_options[:token] = mask_token(safe_options[:token])
      Rails.logger.info "ContactPushNotificationService: FCM options: #{safe_options}"

      options
    end

    def fcm_data
      data = {
        payload: {
          data: {
            message_id: message.id.to_s,
            conversation_id: conversation.id.to_s,
            account_id: account.id.to_s
          }
        }.to_json
      }

      Rails.logger.info "ContactPushNotificationService: FCM data payload: #{data}"
      data
    end

    def fcm_notification
      notification = {
        title: push_message_title,
        body: push_message_body
      }

      Rails.logger.info "ContactPushNotificationService: FCM notification: #{notification}"
      notification
    end

    def fcm_android_options
      {
        priority: 'high'
      }
    end

    def fcm_apns_options
      {
        payload: {
          aps: {
            sound: 'default',
            badge: 1
          }
        }
      }
    end

    # Helper methods for debugging and maintenance

    def mask_token(token)
      return 'nil' unless token
      return token if token.length <= 10

      "#{token[0..5]}...#{token[-4..-1]}"
    end

    def mark_token_as_invalid(reason)
      return unless contact

      Rails.logger.info "ContactPushNotificationService: Marking push token as invalid for contact #{contact.id} - Reason: #{reason}"

      # You might want to implement token cleanup logic here
      # For example:
      # contact.update(push_token: nil, push_token_invalidated_at: Time.current, push_token_invalidation_reason: reason)

      # Or just log for manual review:
      Rails.logger.warn "ContactPushNotificationService: TODO - Clean up invalid token for contact #{contact.id}"
    end

    # Test method for debugging
    def test_notification
      Rails.logger.info 'ContactPushNotificationService: Testing notification capabilities'

      return 'No contact found' unless contact
      return 'No push token' unless contact.push_token.present?

      test_payload = {
        'token': contact.push_token,
        'notification': {
          title: 'Test Notification',
          body: 'This is a test from ContactPushNotificationService'
        }
      }

      Rails.logger.info "ContactPushNotificationService: Test payload: #{test_payload.except(:token)}"

      if chatwoot_hub_enabled?
        ChatwootHub.send_push(test_payload)
        'Test sent via Chatwoot Hub'
      elsif firebase_credentials_present?
        fcm_service = Notification::FcmService.new(
          GlobalConfigService.load('FIREBASE_PROJECT_ID', nil),
          GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)
        )
        response = fcm_service.fcm_client.send_v1(test_payload)
        "Test sent via FCM - Status: #{response[:status_code]}"
      else
        'No push service configured'
      end
    rescue StandardError => e
      "Test failed: #{e.message}"
    end
  end
end
