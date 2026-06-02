class Contacts::PushTokenRenewalService
  pattr_initialize [:contact!, :new_token!, :old_token]

  def perform
    return contact if new_token.blank?
    return contact if contact.push_token == new_token

    log_old_token_mismatch if old_token_mismatch?
    contact.update!(push_token: new_token)
    contact
  end

  private

  def old_token_mismatch?
    old_token.present? && contact.push_token.present? && contact.push_token != old_token
  end

  def log_old_token_mismatch
    Rails.logger.warn(
      "PushTokenRenewalService: old_token mismatch for contact #{contact.id} " \
      "(expected #{old_token[0..10]}..., got #{contact.push_token[0..10]}...)"
    )
  end
end
