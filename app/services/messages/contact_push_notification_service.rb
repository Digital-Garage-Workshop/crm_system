module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    attr_accessor :message

    def initialize(message)
      @message = message
    end

    def perform
      Rails.logger.info "ContactPushNotificationService: Starting push notification for message #{message.id}"

      return unless should_send_push?
      return unless contact&.push_token.present?

      Rails.logger.info "ContactPushNotificationService: Sending push to contact #{contact.id}"

      if chatwoot_hub_enabled?
        send_push_via_chatwoot_hub
      elsif firebase_credentials_present?
        send_fcm_push
      else
        Rails.logger.error "ContactPushNotificationService: No push configuration found"
      end
    rescue StandardError => e
      Rails.logger.error "ContactPushNotificationService: Error: #{e.message}"
      raise e
    end

    private

    def contact
      @contact ||= message&.conversation&.contact
    end

    def conversation
      @conversation ||= message&.conversation
    end

    def account
      @account ||= conversation&.account
    end

    def should_send_push?
      return false unless message&.outgoing?
      return false if message.private?
      return false unless contact
      true
    end

    def sender_name
      message&.sender&.name || account&.name || "Support"
    end

    def push_message_title
      sender_name
    end

    def push_message_body
      return "" unless message&.content
      message.content.truncate(100)
    end

    def send_fcm_push
      fcm_service = Notification::FcmService.new(
        GlobalConfigService.load("FIREBASE_PROJECT_ID", nil),
        GlobalConfigService.load("FIREBASE_CREDENTIALS", nil)
      )

      fcm = fcm_service.fcm_client
      response = fcm.send_v1(fcm_options)
      handle_fcm_response(response)
    end

    def handle_fcm_response(response)
      if response[:status_code] == 200
        Rails.logger.info "ContactPushNotificationService: FCM push sent successfully"
      else
        Rails.logger.error "ContactPushNotificationService: FCM Error #{response[:status_code]}"
      end
    end

    def send_push_via_chatwoot_hub
      ChatwootHub.send_push(fcm_options)
      Rails.logger.info "ContactPushNotificationService: Push sent via Chatwoot Hub"
    end

    def firebase_credentials_present?
      GlobalConfigService.load("FIREBASE_PROJECT_ID", nil).present? &&
        GlobalConfigService.load("FIREBASE_CREDENTIALS", nil).present?
    end

    def chatwoot_hub_enabled?
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("ENABLE_PUSH_RELAY_SERVER", true))
    end

    def fcm_options
      {
        "token": contact.push_token,
        "data": fcm_data,
        "notification": fcm_notification,
        "android": fcm_android_options,
        "apns": fcm_apns_options
      }
    end

    def fcm_data
      {
        payload: {
          data: {
            message_id: message.id.to_s,
            conversation_id: conversation.id.to_s,
            account_id: account.id.to_s
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
        priority: "high"
      }
    end

    def fcm_apns_options
      {
        payload: {
          aps: {
            sound: "default",
            badge: 1
          }
        }
      }
    end
  end
end
