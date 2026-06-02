require 'rails_helper'

RSpec.describe 'Microsoft::CallbacksController', type: :request do
  let(:account) { create(:account) }
  let(:code) { SecureRandom.hex(10) }
  let(:email) { Faker::Internet.email }
<<<<<<< HEAD
  let(:cache_key) { "microsoft::#{email.downcase}" }

  before do
    Redis::Alfred.set(cache_key, account.id)
  end

  describe 'GET /microsoft/callback' do
    let(:response_body_success) do
      { id_token: JWT.encode({ email: email, name: 'test' }, false), access_token: SecureRandom.hex(10), token_type: 'Bearer',
=======
  let(:state) { account.to_sgid(expires_in: 15.minutes).to_s }

  describe 'GET /microsoft/callback' do
    let(:response_body_success) do
      { id_token: JWT.encode({ email: email, name: 'test' }, nil, 'none'), access_token: SecureRandom.hex(10), token_type: 'Bearer',
>>>>>>> upstream/develop
        refresh_token: SecureRandom.hex(10) }
    end

    let(:response_body_success_without_name) do
<<<<<<< HEAD
      { id_token: JWT.encode({ email: email }, false), access_token: SecureRandom.hex(10), token_type: 'Bearer',
=======
      { id_token: JWT.encode({ email: email }, nil, 'none'), access_token: SecureRandom.hex(10), token_type: 'Bearer',
>>>>>>> upstream/develop
        refresh_token: SecureRandom.hex(10) }
    end

    it 'creates inboxes if authentication is successful' do
      stub_request(:post, 'https://login.microsoftonline.com/common/oauth2/v2.0/token')
        .with(body: { 'code' => code, 'grant_type' => 'authorization_code',
                      'redirect_uri' => "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/microsoft/callback" })
        .to_return(status: 200, body: response_body_success.to_json, headers: { 'Content-Type' => 'application/json' })

<<<<<<< HEAD
      get microsoft_callback_url, params: { code: code }
=======
      get microsoft_callback_url, params: { code: code, state: state }
>>>>>>> upstream/develop

      expect(response).to redirect_to app_email_inbox_agents_url(account_id: account.id, inbox_id: account.inboxes.last.id)
      expect(account.inboxes.count).to be 1
      inbox = account.inboxes.last
      expect(inbox.name).to eq 'test'
      expect(inbox.channel.reload.provider_config.keys).to include('access_token', 'refresh_token', 'expires_on')
      expect(inbox.channel.reload.provider_config['access_token']).to eq response_body_success[:access_token]
      expect(inbox.channel.imap_address).to eq 'outlook.office365.com'
<<<<<<< HEAD
      expect(Redis::Alfred.get(cache_key)).to be_nil
=======
    end

    it 'sets imap_login from preferred_username when the id_token carries a UPN that differs from email' do
      upn = 'testaccount@primary-domain.example'
      mailbox = 'TestAccount@mailbox-domain.example'
      response_body = {
        id_token: JWT.encode({ email: mailbox, preferred_username: upn, name: 'test' }, nil, 'none'),
        access_token: SecureRandom.hex(10), token_type: 'Bearer', refresh_token: SecureRandom.hex(10)
      }
      stub_request(:post, 'https://login.microsoftonline.com/common/oauth2/v2.0/token')
        .with(body: { 'code' => code, 'grant_type' => 'authorization_code',
                      'redirect_uri' => "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/microsoft/callback" })
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })

      get microsoft_callback_url, params: { code: code, state: state }

      channel = account.inboxes.last.channel
      expect(channel.imap_login).to eq upn
      expect(channel.email).to eq mailbox
>>>>>>> upstream/develop
    end

    it 'creates updates inbox channel config if inbox exists and authentication is successful' do
      inbox = create(:channel_email, account: account, email: email)&.inbox
      expect(inbox.channel.provider_config).to eq({})

      stub_request(:post, 'https://login.microsoftonline.com/common/oauth2/v2.0/token')
        .with(body: { 'code' => code, 'grant_type' => 'authorization_code',
                      'redirect_uri' => "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/microsoft/callback" })
        .to_return(status: 200, body: response_body_success.to_json, headers: { 'Content-Type' => 'application/json' })

<<<<<<< HEAD
      get microsoft_callback_url, params: { code: code }
=======
      get microsoft_callback_url, params: { code: code, state: state }
>>>>>>> upstream/develop

      expect(response).to redirect_to app_email_inbox_settings_url(account_id: account.id, inbox_id: account.inboxes.last.id)
      expect(account.inboxes.count).to be 1
      expect(inbox.channel.reload.provider_config.keys).to include('access_token', 'refresh_token', 'expires_on')
      expect(inbox.channel.reload.provider_config['access_token']).to eq response_body_success[:access_token]
      expect(inbox.channel.imap_address).to eq 'outlook.office365.com'
<<<<<<< HEAD
      expect(Redis::Alfred.get(cache_key)).to be_nil
=======
>>>>>>> upstream/develop
    end

    it 'creates inboxes with fallback_name when account name is not present in id_token' do
      stub_request(:post, 'https://login.microsoftonline.com/common/oauth2/v2.0/token')
        .with(body: { 'code' => code, 'grant_type' => 'authorization_code',
                      'redirect_uri' => "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/microsoft/callback" })
        .to_return(status: 200, body: response_body_success_without_name.to_json, headers: { 'Content-Type' => 'application/json' })

<<<<<<< HEAD
      get microsoft_callback_url, params: { code: code }
=======
      get microsoft_callback_url, params: { code: code, state: state }
>>>>>>> upstream/develop

      expect(response).to redirect_to app_email_inbox_agents_url(account_id: account.id, inbox_id: account.inboxes.last.id)
      expect(account.inboxes.count).to be 1
      inbox = account.inboxes.last
      expect(inbox.name).to eq email.split('@').first.parameterize.titleize
    end

    it 'redirects to microsoft app in case of error' do
      stub_request(:post, 'https://login.microsoftonline.com/common/oauth2/v2.0/token')
        .with(body: { 'code' => code, 'grant_type' => 'authorization_code',
                      'redirect_uri' => "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/microsoft/callback" })
        .to_return(status: 401)

<<<<<<< HEAD
      get microsoft_callback_url, params: { code: code }

      expect(response).to redirect_to '/'
      expect(Redis::Alfred.get(cache_key).to_i).to eq account.id
=======
      get microsoft_callback_url, params: { code: code, state: state }

      expect(response).to redirect_to '/'
>>>>>>> upstream/develop
    end
  end
end
