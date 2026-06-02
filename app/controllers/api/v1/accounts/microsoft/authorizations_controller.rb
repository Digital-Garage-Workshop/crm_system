<<<<<<< HEAD
class Api::V1::Accounts::Microsoft::AuthorizationsController < Api::V1::Accounts::BaseController
  include MicrosoftConcern
  before_action :check_authorization

  def create
    email = params[:authorization][:email]
    redirect_url = microsoft_client.auth_code.authorize_url(
      {
        redirect_uri: "#{base_url}/microsoft/callback",
        scope: 'offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send openid profile',
=======
class Api::V1::Accounts::Microsoft::AuthorizationsController < Api::V1::Accounts::OauthAuthorizationController
  include MicrosoftConcern

  def create
    redirect_url = microsoft_client.auth_code.authorize_url(
      {
        redirect_uri: "#{base_url}/microsoft/callback",
        scope: scope,
        state: state,
>>>>>>> upstream/develop
        prompt: 'consent'
      }
    )
    if redirect_url
<<<<<<< HEAD
      cache_key = "microsoft::#{email.downcase}"
      ::Redis::Alfred.setex(cache_key, Current.account.id, 5.minutes)
=======
>>>>>>> upstream/develop
      render json: { success: true, url: redirect_url }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
<<<<<<< HEAD

  private

  def check_authorization
    raise Pundit::NotAuthorizedError unless Current.account_user.administrator?
  end
=======
>>>>>>> upstream/develop
end
