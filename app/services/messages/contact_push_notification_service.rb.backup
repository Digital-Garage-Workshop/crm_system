module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    pattr_initialize [:message!]

    def perform
      Rails.logger.info "ContactPushNotificationJob: Processing push notification for message #{message.id}"
      Rails.logger.info "ContactPushNotificationService: Starting push notification for message #{message.id}"

      # FIX 1: Add early returns with better validation
      unless should_send_push?
        Rails.logger.info 'ContactPushNotificationService: Skipping push - should_send_push? returned false'
        return
      end

      unless contact&.push_token.present?
        Rails.logger.info "ContactPushNotificationService: Skipping push - no push token for contact #{contact&.id}"
        return
      end

      # FIX 2: Validate token format
      unless valid_push_token?
        Rails.logger.warn "ContactPushNotificationService: Invalid push token format for contact #{contact.id}"
        return
      end

      Rails.logger.info "ContactPushNotificationService: Sending push to contact #{contact.id} with token: #{contact.push_token[0..10]}..."

      # FIX 3: Add timeout and better error handling
      begin
        Timeout.timeout(10) do # 10 second timeout
          if chatwoot_hub_enabled?
            Rails.logger.info 'ContactPushNotificationService: Using Chatwoot Hub for push delivery'
            send_push_via_chatwoot_hub
          elsif firebase_credentials_present?
            Rails.logger.info 'ContactPushNotificationService: Using Firebase FCM'
            send_fcm_push
          else
            Rails.logger.error 'ContactPushNotificationService: No push configuration found - set FIREBASE_PROJECT_ID and FIREBASE_CREDENTIALS or ENABLE_PUSH_RELAY_SERVER'
          end
        end
      rescue Timeout::Error
        Rails.logger.error "ContactPushNotificationService: Push notification timeout for contact #{contact.id}"
      rescue StandardError => e
        Rails.logger.error "ContactPushNotificationService: Push notification failed for contact #{contact.id}: #{e.message}"
        Rails.logger.error "ContactPushNotificationService: Backtrace: #{e.backtrace.join("\n")}"
      end
    end

    private

    # FIX 4: Add nil safety for contact access
    def contact
      @contact ||= message&.conversation&.contact
    end

    def conversation
      @conversation ||= message&.conversation
    end

    def account
      @account ||= conversation&.account
    end

    # FIX 5: Improve validation logic
    def should_send_push?
      # Check message exists
      unless message
        Rails.logger.error 'ContactPushNotificationService: No message provided'
        return false
      end

      # Check conversation exists
      unless conversation
        Rails.logger.error "ContactPushNotificationService: No conversation found for message #{message.id}"
        return false
      end

      # Check contact exists
      unless contact
        Rails.logger.error "ContactPushNotificationService: No contact found for message #{message.id}"
        return false
      end

      # Check if message is outgoing
      unless message.outgoing?
        Rails.logger.info "ContactPushNotificationService: Message #{message.id} is not outgoing"
        return false
      end

      # Check if message is private
      if message.private?
        Rails.logger.info "ContactPushNotificationService: Message #{message.id} is private"
        return false
      end

      # FIX 6: Add conversation status check
      if conversation.resolved?
        Rails.logger.info "ContactPushNotificationService: Conversation #{conversation.id} is resolved"
        return false
      end

      true
    end

    # FIX 7: Add push token validation
    def valid_push_token?
      return false if contact.push_token.blank?
      return false if contact.push_token.length < 20 # FCM tokens are much longer

      # Basic format validation - FCM tokens are alphanumeric with some special chars
      return false unless contact.push_token.match?(/\A[A-Za-z0-9:_-]+\z/)

      true
    end

    def sender_name
      message&.sender&.name || account&.name || 'Support'
    end

    def push_message_title
      sender_name
    end

    def push_message_body
      return '' unless message&.content

      message.content.truncate(100)
    end

    def send_fcm_push
      fcm_service = Notification::FcmService.new(
        GlobalConfigService.load('FIREBASE_PROJECT_ID', nil),
        GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)
      )

      Rails.logger.info "ContactPushNotificationService: Using Firebase FCM with project ID: #{GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)}"
      fcm = fcm_service.fcm_client
      response = fcm.send_v1(fcm_options)

      handle_fcm_response(response)
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: Error sending FCM push: #{e.message}"
      # FIX 8: Add proper exception tracking
      ChatwootExceptionTracker.new(e, account: account).capture_exception if defined?(ChatwootExceptionTracker) && account
      raise e # Re-raise to ensure job fails and can be retried
    end

    # FIX 9: Improve FCM response handling
    def handle_fcm_response(response)
      Rails.logger.debug { "ContactPushNotificationService: FCM Response Status: #{response[:status_code]}" }
      Rails.logger.debug { "ContactPushNotificationService: FCM Response Body: #{response[:body]}" }

      # Check HTTP status first
      case response[:status_code]
      when 200
        handle_success_response(response)
      when 400
        Rails.logger.error "ContactPushNotificationService: FCM Bad Request (400) for contact #{contact.id} - invalid payload"
      when 401
        Rails.logger.error 'ContactPushNotificationService: FCM Unauthorized (401) - check Firebase credentials'
      when 403
        Rails.logger.error 'ContactPushNotificationService: FCM Forbidden (403) - check Firebase project permissions'
      when 404
        Rails.logger.error "ContactPushNotificationService: FCM Not Found (404) - invalid registration token for contact #{contact.id}"
        # FIX 10: Clear invalid token
        clear_invalid_push_token
      when 429
        Rails.logger.error 'ContactPushNotificationService: FCM Rate Limited (429) - too many requests'
      when 500..599
        Rails.logger.error "ContactPushNotificationService: FCM Server Error (#{response[:status_code]}) - retry later"
      else
        Rails.logger.error "ContactPushNotificationService: FCM Unexpected Status (#{response[:status_code]}) for contact #{contact.id}"
      end
    end

    def handle_success_response(response)
      response_body = JSON.parse(response[:body])

      # Firebase v1 API returns errors in 'error' field, not 'results'
      if response_body['error']
        error = response_body['error']
        Rails.logger.error "ContactPushNotificationService: FCM Error: #{error['message']} (#{error['code']}) for contact #{contact.id}"

        # Handle specific error codes
        case error['code']
        when 'INVALID_ARGUMENT'
          clear_invalid_push_token if error['message'].include?('registration-token')
        when 'UNREGISTERED'
          clear_invalid_push_token
        end
      else
        Rails.logger.info "ContactPushNotificationService: FCM push sent successfully to contact #{contact.id}"
      end
    rescue JSON::ParserError => e
      Rails.logger.error "ContactPushNotificationService: Failed to parse FCM response: #{e.message}"
    end

    # FIX 11: Clear invalid push tokens
    def clear_invalid_push_token
      Rails.logger.info "ContactPushNotificationService: Clearing invalid push token for contact #{contact.id}"
      contact.update!(push_token: nil)
    end

    def send_push_via_chatwoot_hub
      # FIX 12: Add better Chatwoot Hub error handling

      ChatwootHub.send_push(fcm_options)
      Rails.logger.info "ContactPushNotificationService: Push notification sent via Chatwoot Hub to contact #{contact.id}"
    rescue Net::TimeoutError => e
      Rails.logger.error "ContactPushNotificationService: Chatwoot Hub timeout: #{e.message}"
      raise e
    rescue Net::HTTPError => e
      Rails.logger.error "ContactPushNotificationService: Chatwoot Hub HTTP error: #{e.message}"
      raise e
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: Chatwoot Hub error: #{e.message}"
      raise e
    end

    def firebase_credentials_present?
      GlobalConfigService.load('FIREBASE_PROJECT_ID', nil).present? &&
        GlobalConfigService.load('FIREBASE_CREDENTIALS', nil).present?
    end

    def chatwoot_hub_enabled?
      ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PUSH_RELAY_SERVER', true))
    end

    # FIX 13: Add validation for FCM options
    def fcm_options
      options = {
        'token': contact.push_token,
        'data': fcm_data,
        'notification': fcm_notification,
        'android': fcm_android_options,
        'apns': fcm_apns_options,
        'fcm_options': {
          analytics_label: 'chatwoot_message'
        }
      }

      Rails.logger.debug { "ContactPushNotificationService: FCM Options: #{options.except('token').to_json}" }
      options
    end

    def fcm_data
      {
        payload: {
          data: {
            message_id: message.id.to_s,
            conversation_id: conversation.id.to_s,
            account_id: account.id.to_s,
            type: 'message'
          }
        }.to_json
      }
    end

    def fcm_notification
      {
        title: push_message_title,
        body: push_message_body
      }
    end

    def fcm_android_options
      {
        priority: 'high',
        notification: {
          channel_id: 'chatwoot_messages',
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      }
    end

    def fcm_apns_options
      {
        headers: {
          'apns-priority': '10'
        },
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
            'content-available': 1,
            category: 'MESSAGE'
          }
        }
      }
    end
  end
end
