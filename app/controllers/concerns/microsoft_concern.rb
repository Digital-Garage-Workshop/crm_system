module MicrosoftConcern
  extend ActiveSupport::Concern

  def microsoft_client
    app_id = GlobalConfigService.load('AZURE_APP_ID', nil)
    app_secret = GlobalConfigService.load('AZURE_APP_SECRET', nil)

    ::OAuth2::Client.new(app_id, app_secret,
                         {
                           site: 'https://login.microsoftonline.com',
                           authorize_url: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
                           token_url: 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
                         })
  end

  private

<<<<<<< HEAD
  def base_url
    ENV.fetch('FRONTEND_URL', 'http://localhost:3000')
=======
  def scope
    'offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send openid profile email'
>>>>>>> upstream/develop
  end
end
