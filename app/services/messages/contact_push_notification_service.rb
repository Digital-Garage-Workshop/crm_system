module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    pattr_initialize [:message!]

    def perform
      return unless should_send_push?
      return if contact.push_token.blank?

      if firebase_credentials_present?
        send_fcm_push
      elsif chatwoot_hub_enabled?
        send_push_via_chatwoot_hub
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
      message.outgoing? && !message.private? && !message.template?
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
      fcm = fcm_service.fcm_client
      response = fcm.send_v1(fcm_options)

      handle_fcm_response(response)
    rescue StandardError => e
      ChatwootExceptionTracker.new(e, account: account).capture_exception
    end

    def handle_fcm_response(response)
      if JSON.parse(response[:body])['results']&.first&.keys&.include?('error')
        Rails.logger.error("Failed to send push notification to contact #{contact.id}: #{response[:body]}")
      else
        Rails.logger.info("FCM push sent to contact #{contact.id} with title: #{push_message_title}")
      end
    end

    def send_push_via_chatwoot_hub
      ChatwootHub.send_push(fcm_options)
      Rails.logger.info("Push notification sent via Chatwoot Hub to contact #{contact.id}")
    rescue StandardError => e
      Rails.logger.error("Failed to send push via Chatwoot Hub: #{e.message}")
    end

    def firebase_credentials_present?
      GlobalConfigService.load('FIREBASE_PROJECT_ID', nil) && GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)
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
            # Include plate_number if available
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
