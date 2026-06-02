class Internal::RemoveStaleRedisKeysService
  pattr_initialize [:account_id!]

  def perform
    Rails.logger.info "Removing redis stale keys for account #{@account_id}"
<<<<<<< HEAD
    range_start = (Time.zone.now - OnlineStatusTracker::PRESENCE_DURATION).to_i
=======
    range_start = (Time.zone.now - OnlineStatusTracker::CONTACT_PRESENCE_DURATION).to_i
>>>>>>> upstream/develop
    # exclusive minimum score is specified by prefixing (
    # we are clearing old records because this could clogg up the sorted set
    ::Redis::Alfred.zremrangebyscore(
      OnlineStatusTracker.presence_key(@account_id, 'Contact'),
      '-inf',
      "(#{range_start}"
    )
  end
end
