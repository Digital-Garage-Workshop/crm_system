require 'administrate/field/base'

class AccountLimitsField < Administrate::Field::Base
  def to_s
<<<<<<< HEAD
    data.present? ? data.to_json : { agents: nil, inboxes: nil, captain_responses: nil, captain_documents: nil }.to_json
=======
    defaults = { agents: nil, inboxes: nil, captain_responses: nil, captain_documents: nil, emails: nil }
    overrides = (data.presence || {}).to_h.symbolize_keys.compact

    defaults.merge(overrides).to_json
>>>>>>> upstream/develop
  end
end
