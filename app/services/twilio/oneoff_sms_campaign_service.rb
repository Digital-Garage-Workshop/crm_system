class Twilio::OneoffSmsCampaignService
  pattr_initialize [:campaign!]

  def perform
    raise "Invalid campaign #{campaign.id}" if campaign.inbox.inbox_type != 'Twilio SMS' || !campaign.one_off?
    raise 'Completed Campaign' if campaign.completed?

<<<<<<< HEAD
    # marks campaign completed so that other jobs won't pick it up
    campaign.completed!

    audience_label_ids = campaign.audience.select { |audience| audience['type'] == 'Label' }.pluck('id')
    audience_labels = campaign.account.labels.where(id: audience_label_ids).pluck(:title)
    process_audience(audience_labels)
=======
    audience_label_ids = campaign.audience.select { |audience| audience['type'] == 'Label' }.pluck('id')
    audience_labels = campaign.account.labels.where(id: audience_label_ids).pluck(:title)
    process_audience(audience_labels)
    campaign.completed!
>>>>>>> upstream/develop
  end

  private

  delegate :inbox, to: :campaign
  delegate :channel, to: :inbox

  def process_audience(audience_labels)
    campaign.account.contacts.tagged_with(audience_labels, any: true).each do |contact|
      next if contact.phone_number.blank?

<<<<<<< HEAD
      channel.send_message(to: contact.phone_number, body: campaign.message)
=======
      content = Liquid::CampaignTemplateService.new(campaign: campaign, contact: contact).call(campaign.message)

      begin
        channel.send_message(to: contact.phone_number, body: content)
      rescue Twilio::REST::TwilioError, Twilio::REST::RestError => e
        Rails.logger.error("[Twilio Campaign #{campaign.id}] Failed to send to #{contact.phone_number}: #{e.message}")
        next
      end
>>>>>>> upstream/develop
    end
  end
end
