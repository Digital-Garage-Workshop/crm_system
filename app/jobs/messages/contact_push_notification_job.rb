module Messages
  class ContactPushNotificationJob < ApplicationJob
    queue_as :medium

    def perform(message_id)
      message = Message.find_by(id: message_id)

      if message.nil?
        Rails.logger.error "ContactPushNotificationJob: Message #{message_id} not found"
        return
      end

      Rails.logger.info "ContactPushNotificationJob: Processing push notification for message #{message_id}"
      Messages::ContactPushNotificationService.new(message: message).perform
    end
  end
end
