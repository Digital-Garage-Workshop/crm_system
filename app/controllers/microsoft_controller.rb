class MicrosoftController < ApplicationController
  after_action :set_version_header

  def identity_association
<<<<<<< HEAD
    microsoft_indentity
=======
    microsoft_identity
>>>>>>> upstream/develop
  end

  private

  def set_version_header
    response.headers['Content-Length'] = { associatedApplications: [{ applicationId: @identity_json }] }.to_json.length
  end

<<<<<<< HEAD
  def microsoft_indentity
=======
  def microsoft_identity
>>>>>>> upstream/develop
    @identity_json = GlobalConfigService.load('AZURE_APP_ID', nil)
  end
end
