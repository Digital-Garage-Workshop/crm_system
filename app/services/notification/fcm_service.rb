class Notification::FcmService
  SCOPES = ['https://www.googleapis.com/auth/firebase.messaging'].freeze

  def initialize(project_id, credentials)
    @project_id = project_id
    @credentials = credentials
    @token_info = nil

    validate_credentials!
  end

  def fcm_client
    FCM.new(current_token, credentials_path, @project_id)
  end

  private

  def validate_credentials!
    raise ArgumentError, 'Firebase project_id cannot be blank' if @project_id.blank?
    raise ArgumentError, 'Firebase credentials cannot be blank' if @credentials.blank?

    # Try to parse credentials to ensure they're valid JSON
    JSON.parse(@credentials)
  rescue JSON::ParserError => e
    raise ArgumentError, "Invalid Firebase credentials JSON: #{e.message}"
  end

  def current_token
    @token_info = generate_token if @token_info.nil? || token_expired?
    @token_info[:token]
  end

  def token_expired?
    return true if @token_info.nil? || @token_info[:expires_at].nil?

    Time.zone.now >= @token_info[:expires_at]
  end

  def generate_token
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: credentials_path,
      scope: SCOPES
    )
    token = authorizer.fetch_access_token!
    {
      token: token['access_token'],
      expires_at: Time.zone.now + token['expires_in'].to_i
    }
  rescue StandardError => e
    Rails.logger.error "Failed to generate Firebase access token: #{e.class} - #{e.message}"
    raise
  end

  def credentials_path
    StringIO.new(@credentials)
  end
end
