require 'rails_helper'

describe Messages::ContactPushNotificationService do
  let(:account) { create(:account) }
  let(:conversation) { create(:conversation, account: account) }
  let(:contact) { conversation.contact }
  let(:agent) { create(:user, account: account) }

  before do
    contact.update(push_token: 'test_push_token_123')
  end

  context 'when message is outgoing from agent' do
    let(:message) { create(:message, conversation: conversation, account: account, message_type: :outgoing, sender: agent) }

    it 'attempts to send push notification to contact' do
      allow_any_instance_of(described_class).to receive(:firebase_credentials_present?).and_return(true)
      expect_any_instance_of(described_class).to receive(:send_fcm_push)

      described_class.new(message: message).perform
    end
  end

  context 'when message is not notifiable' do
    let(:private_message) { create(:message, conversation: conversation, account: account, message_type: :outgoing, sender: agent, private: true) }
    let(:incoming_message) { create(:message, conversation: conversation, account: account, message_type: :incoming) }

    it 'does not send push notification for private messages' do
      expect_any_instance_of(described_class).not_to receive(:send_fcm_push)
      expect_any_instance_of(described_class).not_to receive(:send_push_via_chatwoot_hub)

      described_class.new(message: private_message).perform
    end

    it 'does not send push notification for incoming messages' do
      expect_any_instance_of(described_class).not_to receive(:send_fcm_push)
      expect_any_instance_of(described_class).not_to receive(:send_push_via_chatwoot_hub)

      described_class.new(message: incoming_message).perform
    end
  end
end
