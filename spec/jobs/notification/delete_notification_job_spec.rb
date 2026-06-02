require 'rails_helper'

RSpec.describe Notification::DeleteNotificationJob do
  let(:user) { create(:user) }
<<<<<<< HEAD
=======
  let(:account) { create(:account) }
>>>>>>> upstream/develop
  let(:conversation) { create(:conversation) }

  context 'when enqueuing the job' do
    it 'enqueues the job to delete all notifications' do
      expect do
<<<<<<< HEAD
        described_class.perform_later(user.id, type: :all)
=======
        described_class.perform_later(user, account, type: :all)
>>>>>>> upstream/develop
      end.to have_enqueued_job(described_class).on_queue('low')
    end

    it 'enqueues the job to delete read notifications' do
      expect do
<<<<<<< HEAD
        described_class.perform_later(user.id, type: :read)
=======
        described_class.perform_later(user, account, type: :read)
>>>>>>> upstream/develop
      end.to have_enqueued_job(described_class).on_queue('low')
    end
  end

  context 'when performing the job' do
<<<<<<< HEAD
    before do
      create(:notification, user: user, read_at: nil)
      create(:notification, user: user, read_at: Time.current)
    end

    it 'deletes all notifications' do
      described_class.perform_now(user, type: :all)
      expect(user.notifications.count).to eq(0)
    end

    it 'deletes only read notifications' do
      described_class.perform_now(user, type: :read)
      expect(user.notifications.count).to eq(1)
      expect(user.notifications.where(read_at: nil).count).to eq(1)
=======
    let(:other_account) { create(:account) }

    before do
      create(:notification, account: account, user: user, read_at: nil)
      create(:notification, account: account, user: user, read_at: Time.current)
      create(:notification, account: other_account, user: user, read_at: Time.current)
    end

    it 'deletes all notifications for the requested account' do
      described_class.perform_now(user, account, type: :all)

      expect(user.notifications.where(account_id: account.id).count).to eq(0)
      expect(user.notifications.where(account_id: other_account.id).count).to eq(1)
    end

    it 'deletes only read notifications for the requested account' do
      described_class.perform_now(user, account, type: :read)

      expect(user.notifications.where(account_id: account.id).count).to eq(1)
      expect(user.notifications.where(account_id: account.id, read_at: nil).count).to eq(1)
      expect(user.notifications.where(account_id: other_account.id).count).to eq(1)
>>>>>>> upstream/develop
    end
  end
end
