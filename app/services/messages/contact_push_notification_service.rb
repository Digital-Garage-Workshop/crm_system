module Messages
  class ContactPushNotificationService
    include Rails.application.routes.url_helpers

    pattr_initialize [:message!]

    def perform
      return unless should_send_push?

      if contact.push_token.blank?
        Rails.logger.info("ContactPushNotificationService: No push token for contact #{contact.id}")
        return
      end

      Rails.logger.info("ContactPushNotificationService: Sending push to contact #{contact.id} with token: #{contact.push_token[0..20]}...")

      # Try Firebase first if credentials are available
      if firebase_credentials_present?
        Rails.logger.info('ContactPushNotificationService: Using direct FCM')
        success = send_fcm_push

        if success
          Rails.logger.info("ContactPushNotificationService: Successfully sent via direct FCM to contact #{contact.id}")
          return
        else
          Rails.logger.warn("ContactPushNotificationService: Direct FCM failed for contact #{contact.id}, trying Chatwoot Hub as fallback")
        end
      end

      # Try Chatwoot Hub (either as primary method or fallback)
      if chatwoot_hub_enabled?
        Rails.logger.info('ContactPushNotificationService: Using Chatwoot Hub')
        hub_success = send_push_via_chatwoot_hub

        if hub_success
          Rails.logger.info("ContactPushNotificationService: Successfully sent via Chatwoot Hub to contact #{contact.id}")
          return
        else
          Rails.logger.error("ContactPushNotificationService: Chatwoot Hub failed for contact #{contact.id}")
        end
      end

      # If we get here, both methods failed or are unavailable
      Rails.logger.error('ContactPushNotificationService: No push notification method available or all methods failed')
      Rails.logger.error('To enable push notifications, set up Firebase credentials or ensure Chatwoot Hub is working')
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
      project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)
      credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)

      if project_id.blank? || credentials.blank?
        Rails.logger.error("ContactPushNotificationService: Firebase credentials not configured - project_id: #{project_id.present?}, credentials: #{credentials.present?}")
        return false
      end

      Rails.logger.info("ContactPushNotificationService: Attempting direct FCM with project: #{project_id}")

      fcm_service = Notification::FcmService.new(project_id, credentials)
      fcm = fcm_service.fcm_client
      response = fcm.send_v1(fcm_options)

      handle_fcm_response(response)
      true
    rescue ArgumentError => e
      Rails.logger.error("ContactPushNotificationService: Invalid Firebase configuration: #{e.message}")
      false
    rescue StandardError => e
      Rails.logger.error("ContactPushNotificationService: FCM error for contact #{contact.id}: #{e.class} - #{e.message}")
      ChatwootExceptionTracker.new(e, account: account).capture_exception
      false
    end

    def handle_fcm_response(response)
      if JSON.parse(response[:body])['results']&.first&.keys&.include?('error')
        Rails.logger.error("Failed to send push notification to contact #{contact.id}: #{response[:body]}")
      else
        Rails.logger.info("FCM push sent to contact #{contact.id} with title: #{push_message_title}")
      end
    end

    def send_push_via_chatwoot_hub
      Rails.logger.info("ContactPushNotificationService: Sending to Hub with FCM options: #{fcm_options.except(:token).inspect}")
      response = ChatwootHub.send_push(fcm_options)

      if response
        parsed_response = begin
          JSON.parse(response.body)
        rescue StandardError
          {}
        end
        if parsed_response['success'] == false
          Rails.logger.error("Chatwoot Hub push failed for contact #{contact.id}: #{parsed_response['error']}")
          false
        else
          Rails.logger.info("Push notification sent via Chatwoot Hub to contact #{contact.id}")
          true
        end
      else
        Rails.logger.error("No response from Chatwoot Hub for contact #{contact.id}")
        false
      end
    rescue StandardError => e
      Rails.logger.error("Failed to send push via Chatwoot Hub to contact #{contact.id}: #{e.class} - #{e.message}")
      Rails.logger.error("Full backtrace: #{e.backtrace.first(5).join("\n")}")
      false
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
