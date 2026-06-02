class Notification::DeleteNotificationJob < ApplicationJob
  queue_as :low

<<<<<<< HEAD
  def perform(user, type: :all)
    ActiveRecord::Base.transaction do
      if type == :all
        # Delete all notifications
        user.notifications.destroy_all
      elsif type == :read
        # Delete only read notifications
        user.notifications.where.not(read_at: nil).destroy_all
=======
  def perform(user, account, type: :all)
    notifications = user.notifications.where(account_id: account.id)

    ActiveRecord::Base.transaction do
      if type == :all
        notifications.destroy_all
      elsif type == :read
        notifications.where.not(read_at: nil).destroy_all
>>>>>>> upstream/develop
      end
    end
  end
end
