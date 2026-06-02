<<<<<<< HEAD
class Widget::TokenService
  pattr_initialize [:payload, :token]

  def generate_token
    JWT.encode payload, secret_key, 'HS256'
  end

  def decode_token
    JWT.decode(
      token, secret_key, true, algorithm: 'HS256'
    ).first.symbolize_keys
  rescue StandardError
    {}
=======
class Widget::TokenService < BaseTokenService
  DEFAULT_EXPIRY_DAYS = 180

  def generate_token
    JWT.encode(token_payload, secret_key, algorithm)
>>>>>>> upstream/develop
  end

  private

<<<<<<< HEAD
  def secret_key
    Rails.application.secret_key_base
=======
  def token_payload
    (payload || {}).merge(exp: exp, iat: iat)
  end

  def iat
    Time.zone.now.to_i
  end

  def exp
    iat + expire_in.days.to_i
  end

  def expire_in
    # Value is stored in days, defaulting to 6 months (180 days)
    token_expiry_value = InstallationConfig.find_by(name: 'WIDGET_TOKEN_EXPIRY')&.value
    (token_expiry_value.presence || DEFAULT_EXPIRY_DAYS).to_i
>>>>>>> upstream/develop
  end
end
