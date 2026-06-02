module Enterprise::Audit::Webhook
  extend ActiveSupport::Concern

  included do
<<<<<<< HEAD
    audited associated_with: :account
=======
    audited associated_with: :account, except: [:secret]
>>>>>>> upstream/develop
  end
end
