class Messages::MentionService
  pattr_initialize [:message!]

  def perform
    return unless valid_mention_message?(message)

    validated_mentioned_ids = filter_mentioned_ids_by_inbox
    return if validated_mentioned_ids.blank?

    Conversations::UserMentionJob.perform_later(validated_mentioned_ids, message.conversation.id, message.account.id)
<<<<<<< HEAD
    generate_notifications_for_mentions(validated_mentioned_ids)
    add_mentioned_users_as_participants(validated_mentioned_ids)
=======
    add_mentioned_users_as_participants(validated_mentioned_ids)
    generate_notifications_for_mentions(validated_mentioned_ids)
>>>>>>> upstream/develop
  end

  private

  def valid_mention_message?(message)
    message.private? && message.content.present? && mentioned_ids.present?
  end

  def mentioned_ids
<<<<<<< HEAD
    @mentioned_ids ||= message.content.scan(%r{\(mention://(user|team)/(\d+)/(.+?)\)}).map(&:second).uniq
  end

  def filter_mentioned_ids_by_inbox
    inbox = message.inbox
    valid_mentionable_ids = inbox.account.administrators.map(&:id) + inbox.members.map(&:id)
    # Intersection of ids
    mentioned_ids & valid_mentionable_ids.uniq.map(&:to_s)
=======
    user_mentions = message.content.scan(%r{\(mention://user/(\d+)/(.+?)\)}).map(&:first)
    team_mentions = message.content.scan(%r{\(mention://team/(\d+)/(.+?)\)}).map(&:first)

    expanded_user_ids = expand_team_mentions_to_users(team_mentions)

    (user_mentions + expanded_user_ids).uniq
  end

  def expand_team_mentions_to_users(team_ids)
    return [] if team_ids.blank?

    message.inbox.account.teams
           .joins(:team_members)
           .where(id: team_ids)
           .pluck('team_members.user_id')
           .map(&:to_s)
  end

  def valid_mentionable_user_ids
    @valid_mentionable_user_ids ||= begin
      inbox = message.inbox
      inbox.account.administrators.pluck(:id) + inbox.members.pluck(:id)
    end
  end

  def filter_mentioned_ids_by_inbox
    mentioned_ids & valid_mentionable_user_ids.map(&:to_s)
>>>>>>> upstream/develop
  end

  def generate_notifications_for_mentions(validated_mentioned_ids)
    validated_mentioned_ids.each do |user_id|
<<<<<<< HEAD
=======
      next if self_mention?(user_id)

>>>>>>> upstream/develop
      NotificationBuilder.new(
        notification_type: 'conversation_mention',
        user: User.find(user_id),
        account: message.account,
        primary_actor: message.conversation,
        secondary_actor: message
      ).perform
    end
  end

<<<<<<< HEAD
=======
  def self_mention?(user_id)
    message.sender_type == 'User' && user_id.to_i == message.sender_id
  end

>>>>>>> upstream/develop
  def add_mentioned_users_as_participants(validated_mentioned_ids)
    validated_mentioned_ids.each do |user_id|
      message.conversation.conversation_participants.find_or_create_by(user_id: user_id)
    end
  end
end
