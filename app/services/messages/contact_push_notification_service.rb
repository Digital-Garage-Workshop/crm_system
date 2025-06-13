module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    pattr_initialize [:message!]

    def perform
      Rails.logger.info "ContactPushNotificationService: Starting push notification for message #{message.id}"

      return unless should_send_push?
      return if contact.push_token.blank?

      Rails.logger.info "ContactPushNotificationService: Sending push to contact #{contact.id} with token: #{contact.push_token[0..10]}..."

      if firebase_credentials_present?
        send_fcm_push
      elsif chatwoot_hub_enabled?
        send_push_via_chatwoot_hub
      else
        Rails.logger.error 'ContactPushNotificationService: No push configuration found - set FIREBASE_PROJECT_ID and FIREBASE_CREDENTIALS or ENABLE_PUSH_RELAY_SERVER'
      end
    end

    private

    def contact
      @contact ||= message.conversation.contact
    end

    def conversation
      message.conversation
    end

    def account
      conversation.account
    end

    def should_send_push?
      unless message.outgoing?
        Rails.logger.info "ContactPushNotificationService: Message #{message.id} is not outgoing"
        return false
      end

      if message.private?
        Rails.logger.info "ContactPushNotificationService: Message #{message.id} is private"
        return false
      end

      true
    end

    def sender_name
      message.sender&.name || account.name
    end

    def push_message_title
      "#{sender_name}"
    end

    def push_message_body
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
      ChatwootExceptionTracker.new(e, account: account).capture_exception
    end

    def handle_fcm_response(response)
      response_body = JSON.parse(response[:body])
      if response_body['results']&.first&.keys&.include?('error')
        error = response_body['results'].first['error']
        Rails.logger.error "ContactPushNotificationService: FCM Error: #{error} for contact #{contact.id}"
      else
        Rails.logger.info "ContactPushNotificationService: FCM push sent successfully to contact #{contact.id}"
      end
    end

    def send_push_via_chatwoot_hub
      Rails.logger.info 'ContactPushNotificationService: Using Chatwoot Hub for push delivery'
      ChatwootHub.send_push(fcm_options)
      Rails.logger.info "ContactPushNotificationService: Push notification sent via Chatwoot Hub to contact #{contact.id}"
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: Error sending via Hub: #{e.message}"
    end

    def firebase_credentials_present?
      GlobalConfigService.load('FIREBASE_PROJECT_ID', nil).present? &&
        GlobalConfigService.load('FIREBASE_CREDENTIALS', nil).present?
    end

    def chatwoot_hub_enabled?
      ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PUSH_RELAY_SERVER', true))
    end

    def fcm_options
      {
        'token': contact.push_token,
        'data': fcm_data,
        'notification': fcm_notification,
        'android': fcm_android_options,
        'apns': fcm_apns_options,
        'fcm_options': {
          analytics_label: 'contact_message'
        }
      }
    end

    def fcm_data
      {
        payload: {
          data: {
            message_id: message.id,
            conversation_id: conversation.display_id,
            account_id: account.id,
            inbox_id: message.inbox_id,
            message_content: message.content,
            created_at: message.created_at.to_i,
            plate_number: contact.respond_to?(:plate_number) ? contact.plate_number : nil
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
        priority: 'high'
      }
    end

    def fcm_apns_options
      {
        payload: {
          aps: {
            sound: 'default',
            category: Time.zone.now.to_i.to_s,
            'mutable-content': 1
          }
        }
      }
    end
  end
end
