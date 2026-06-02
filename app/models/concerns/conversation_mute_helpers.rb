module ConversationMuteHelpers
  extend ActiveSupport::Concern

  def mute!
<<<<<<< HEAD
=======
    return unless contact

>>>>>>> upstream/develop
    resolved!
    contact.update(blocked: true)
    create_muted_message
  end

  def unmute!
<<<<<<< HEAD
=======
    return unless contact

>>>>>>> upstream/develop
    contact.update(blocked: false)
    create_unmuted_message
  end

  def muted?
<<<<<<< HEAD
    contact.blocked?
=======
    contact&.blocked? || false
>>>>>>> upstream/develop
  end
end
