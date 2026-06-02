<<<<<<< HEAD
class Api::V1::Accounts::Instagram::AuthorizationsController < Api::V1::Accounts::BaseController
  include InstagramConcern
  include Instagram::IntegrationHelper
  before_action :check_authorization
=======
class Api::V1::Accounts::Instagram::AuthorizationsController < Api::V1::Accounts::OauthAuthorizationController
  include InstagramConcern
  include Instagram::IntegrationHelper
>>>>>>> upstream/develop

  def create
    # https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login/business-login#step-1--get-authorization
    redirect_url = instagram_client.auth_code.authorize_url(
      {
        redirect_uri: "#{base_url}/instagram/callback",
        scope: REQUIRED_SCOPES.join(','),
        enable_fb_login: '0',
        force_authentication: '1',
        response_type: 'code',
        state: generate_instagram_token(Current.account.id)
      }
    )
    if redirect_url
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
