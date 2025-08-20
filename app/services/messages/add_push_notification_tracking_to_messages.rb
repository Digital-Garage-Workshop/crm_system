# db/migrate/add_push_notification_tracking_to_messages.rb
class AddPushNotificationTrackingToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :push_notification_sent_at, :datetime, null: true
    add_column :messages, :push_notification_error, :text, null: true

    add_index :messages, :push_notification_sent_at
    add_index :messages, [:conversation_id, :push_notification_sent_at]
  end
end

# Then add these methods to your Message model:
# app/models/message.rb
class Message < ApplicationRecord
  # ... existing code ...

  def push_notification_sent?
    push_notification_sent_at.present?
  end

  def update_push_notification_sent!(sent = true, error = nil)
    if sent
      update!(
        push_notification_sent_at: Time.current,
        push_notification_error: nil
      )
    else
      update!(
        push_notification_sent_at: nil,
        push_notification_error: error
      )
    end
  end

  def mark_push_notification_failed!(error_message)
    update!(
      push_notification_sent_at: nil,
      push_notification_error: error_message
    )
  end
end
