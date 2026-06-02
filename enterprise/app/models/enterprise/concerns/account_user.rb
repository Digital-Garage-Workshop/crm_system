module Enterprise::Concerns::AccountUser
  extend ActiveSupport::Concern

  included do
    belongs_to :custom_role, optional: true
<<<<<<< HEAD
=======
    belongs_to :agent_capacity_policy, optional: true
>>>>>>> upstream/develop
  end
end
