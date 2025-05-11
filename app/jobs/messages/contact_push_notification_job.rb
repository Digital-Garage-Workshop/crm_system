module Messages
  class ContactPushNotificationJob < ApplicationJob
    queue_as :medium

    def perform(message_id)
      @message = Message.find_by(id: message_id)
      return if @message.blank?

      Messages::ContactPushNotificationService.new(message: @message).perform
    end
  end
end
