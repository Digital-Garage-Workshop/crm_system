module GoogleConcern
  extend ActiveSupport::Concern

  def google_client
    app_id = GlobalConfigService.load('GOOGLE_OAUTH_CLIENT_ID', nil)
    app_secret = GlobalConfigService.load('GOOGLE_OAUTH_CLIENT_SECRET', nil)

    ::OAuth2::Client.new(app_id, app_secret, {
                           site: 'https://oauth2.googleapis.com',
                           authorize_url: 'https://accounts.google.com/o/oauth2/auth',
                           token_url: 'https://accounts.google.com/o/oauth2/token'
                         })
  end

  private

<<<<<<< HEAD
  def base_url
    ENV.fetch('FRONTEND_URL', 'http://localhost:3000')
=======
  def scope
    'email profile https://mail.google.com/'
>>>>>>> upstream/develop
  end
end
