json.meta do
  json.count @contacts_count
  json.current_page @current_page
end

json.payload do
  json.array! @contacts do |contact|
<<<<<<< HEAD
    json.partial! 'api/v1/models/contact', formats: [:json], resource: contact, with_contact_inboxes: true
=======
    json.partial! 'api/v1/models/contact', formats: [:json], resource: contact, with_contact_inboxes: @include_contact_inboxes
>>>>>>> upstream/develop
  end
end
