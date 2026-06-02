class Captain::Tools::FirecrawlParserJob < ApplicationJob
  queue_as :low

  def perform(assistant_id:, payload:)
    assistant = Captain::Assistant.find(assistant_id)
    metadata = payload[:metadata]

<<<<<<< HEAD
    document = assistant.documents.find_or_initialize_by(
      external_link: metadata['url']
    )

    document.update!(
      content: payload[:markdown],
      name: metadata['title'],
      status: :available
=======
    canonical_url = normalize_link(metadata['url'])
    document = assistant.documents.find_or_initialize_by(
      external_link: canonical_url
    )

    document.update!(
      external_link: canonical_url,
      content: payload[:markdown],
      name: metadata['title'],
      status: :available,
      sync_status: :synced,
      last_synced_at: Time.current,
      last_sync_attempted_at: Time.current,
      last_sync_error_code: nil
>>>>>>> upstream/develop
    )
  rescue StandardError => e
    raise "Failed to parse FireCrawl data: #{e.message}"
  end
<<<<<<< HEAD
=======

  private

  def normalize_link(raw_url)
    raw_url.to_s.delete_suffix('/')
  end
>>>>>>> upstream/develop
end
