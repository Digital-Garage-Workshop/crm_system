class Twilio::CallbackController < ApplicationController
  def create
    Webhooks::TwilioEventsJob.perform_later(permitted_params.to_unsafe_hash)

    head :no_content
  end

  private

  def permitted_params # rubocop:disable Metrics/MethodLength
    params.permit(
      :ApiVersion,
      :SmsSid,
      :From,
      :ToState,
      :ToZip,
      :AccountSid,
      :MessageSid,
      :FromCountry,
      :ToCity,
      :FromCity,
      :To,
      :FromZip,
      :Body,
      :ToCountry,
      :FromState,
<<<<<<< HEAD
      :MediaUrl0,
      :MediaContentType0,
      :MessagingServiceSid
=======
      *Array.new(10) { |i| :"MediaUrl#{i}" },
      *Array.new(10) { |i| :"MediaContentType#{i}" },
      :MessagingServiceSid,
      :NumMedia,
      :Latitude,
      :Longitude,
      :MessageType,
      :ProfileName,
      :ExternalUserId,
      :ParentExternalUserId,
      :ProfileUsername,
      :Username
>>>>>>> upstream/develop
    )
  end
end
