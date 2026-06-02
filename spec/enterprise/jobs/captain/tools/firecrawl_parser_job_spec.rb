require 'rails_helper'

RSpec.describe Captain::Tools::FirecrawlParserJob, type: :job do
  describe '#perform' do
    let(:assistant) { create(:captain_assistant) }
    let(:payload) do
      {
        markdown: 'Launch Week I is here! 🚀',
        metadata: {
          'title' => 'Home - Firecrawl',
          'ogTitle' => 'Firecrawl',
          'url' => 'https://www.firecrawl.dev/'
        }
      }
    end

    it 'creates a new document when one does not exist' do
<<<<<<< HEAD
      expect do
        described_class.perform_now(assistant_id: assistant.id, payload: payload)
      end.to change(assistant.documents, :count).by(1)

      document = assistant.documents.last
      expect(document).to have_attributes(
        content: payload[:markdown],
        name: payload[:metadata]['title'],
        external_link: payload[:metadata]['url'],
        status: 'available'
      )
=======
      freeze_time do
        expect do
          described_class.perform_now(assistant_id: assistant.id, payload: payload)
        end.to change(assistant.documents, :count).by(1)

        document = assistant.documents.last
        expect(document).to have_attributes(
          content: payload[:markdown],
          name: payload[:metadata]['title'],
          external_link: 'https://www.firecrawl.dev',
          status: 'available',
          sync_status: 'synced',
          last_synced_at: Time.current,
          last_sync_attempted_at: Time.current
        )
      end
>>>>>>> upstream/develop
    end

    it 'updates existing document when one exists' do
      existing_document = create(:captain_document,
                                 assistant: assistant,
                                 account: assistant.account,
<<<<<<< HEAD
                                 external_link: payload[:metadata]['url'],
=======
                                 external_link: 'https://www.firecrawl.dev',
>>>>>>> upstream/develop
                                 content: 'old content',
                                 name: 'old title',
                                 status: :in_progress)

<<<<<<< HEAD
      expect do
        described_class.perform_now(assistant_id: assistant.id, payload: payload)
      end.not_to change(assistant.documents, :count)

      existing_document.reload
      expect(existing_document).to have_attributes(
        content: payload[:markdown],
        name: payload[:metadata]['title'],
        status: 'available'
      )
=======
      freeze_time do
        expect do
          described_class.perform_now(assistant_id: assistant.id, payload: payload)
        end.not_to change(assistant.documents, :count)

        existing_document.reload
        # Payload URL ends with '/', but we persist the canonical URL without it.
        expect(existing_document).to have_attributes(
          external_link: 'https://www.firecrawl.dev',
          content: payload[:markdown],
          name: payload[:metadata]['title'],
          status: 'available',
          sync_status: 'synced',
          last_synced_at: Time.current,
          last_sync_attempted_at: Time.current
        )
      end
    end

    it 'stores external links longer than 255 characters' do
      long_url = "https://example.com/#{'arabic-product-slug-' * 300}"
      payload[:metadata]['url'] = long_url

      described_class.perform_now(assistant_id: assistant.id, payload: payload)

      expect(assistant.documents.last.external_link).to eq(long_url)
      expect(assistant.documents.last.external_link.length).to be > 255
>>>>>>> upstream/develop
    end

    context 'when an error occurs' do
      it 'raises an error with a descriptive message' do
        allow(Captain::Assistant).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

        expect do
          described_class.perform_now(assistant_id: -1, payload: payload)
        end.to raise_error(/Failed to parse FireCrawl data/)
      end
    end
  end
end
