module Messages
  class ContactPushNotificationJob < ApplicationJob
    queue_as :medium

    def perform(message_id)
      Rails.logger.info "[PUSH-JOB] ContactPushNotificationJob эхэллээ. message_id=#{message_id}"

      @message = Message.find_by(id: message_id)
      if @message.blank?
        Rails.logger.warn '[PUSH-JOB] @message хоосон байна. Push notification илгээхгүй.'
        return
      end

      Rails.logger.info "[PUSH-JOB] @message олдлоо (id=#{@message.id}), push notification сервис рүү илгээж байна."
      Messages::ContactPushNotificationService.new(message: @message).perform
    end
  end
end
