module Messages
  class ContactPushNotificationJob < ApplicationJob
    queue_as :medium

    def perform(message_id)
      Rails.logger.info "[ContactPushNotificationJob] Processing message #{message_id}"

      message = Message.find_by(id: message_id)
      unless message
        Rails.logger.error "[ContactPushNotificationJob] Message #{message_id} not found"
        return
      end

      begin
        service = Messages::ContactPushNotificationService.new(message)
        service.perform
        Rails.logger.info "[ContactPushNotificationJob] Successfully processed message #{message_id}"
      rescue StandardError => e
        Rails.logger.error "[ContactPushNotificationJob] Error: #{e.message}"
        raise e
      end
    end
  end
end
