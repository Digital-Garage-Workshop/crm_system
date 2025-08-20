# app/jobs/messages/contact_push_notification_job.rb
module Messages
  class ContactPushNotificationJob < ApplicationJob
    queue_as :medium

    # FIX 1: Add retry configuration
    retry_on StandardError, wait: :polynomially_longer, attempts: 3

    # FIX 2: Discard job for specific errors that shouldn't be retried
    discard_on ActiveRecord::RecordNotFound

    # FIX 3: Add job uniqueness to prevent duplicates (if using sidekiq-unique-jobs gem)
    # unique :until_executed, on_conflict: :log

    def perform(message_id)
      Rails.logger.info "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Performing Messages::ContactPushNotificationJob (Job ID: #{job_id}) with arguments: #{message_id}"

      # FIX 4: Add validation and early return
      message = Message.find_by(id: message_id)
      unless message
        Rails.logger.error "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Message #{message_id} not found"
        return
      end

      # FIX 5: Check if notification was already sent (if you add this field to Message model)
      if message.respond_to?(:push_notification_sent?) && message.push_notification_sent?
        Rails.logger.info "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Push notification already sent for message #{message_id}"
        return
      end

      Rails.logger.info "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] ContactPushNotificationJob: Processing push notification for message #{message_id}"

      # FIX 6: Use begin/rescue to handle errors properly
      begin
        service = Messages::ContactPushNotificationService.new(message)
        service.perform

        # FIX 7: Mark as sent (if you add this field to Message model)
        message.update_push_notification_sent!(true) if message.respond_to?(:update_push_notification_sent!)

        Rails.logger.info "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Performed Messages::ContactPushNotificationJob successfully"
      rescue StandardError => e
        Rails.logger.error "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Error in ContactPushNotificationJob: #{e.message}"
        Rails.logger.error "[ActiveJob] [Messages::ContactPushNotificationJob] [#{job_id}] Backtrace: #{e.backtrace.join("\n")}"

        # Re-raise to trigger retry mechanism
        raise e
      end
    end
  end
end
