module Enterprise::Conversations::PermissionFilterService
  def perform
<<<<<<< HEAD
    account_user = AccountUser.find_by(account_id: account.id, user_id: user.id)
    permissions = account_user&.permissions || []
    user_role = account_user&.role

    # Skip filtering for administrators
    return conversations if user_role == 'administrator'
    # Skip filtering for regular agents (without custom roles/permissions)
    return conversations if user_role == 'agent' && account_user&.custom_role_id.nil?

    filter_by_permissions(permissions)
=======
    return filter_by_permissions(permissions) if user_has_custom_role?

    super
>>>>>>> upstream/develop
  end

  private

<<<<<<< HEAD
=======
  def user_has_custom_role?
    user_role == 'agent' && account_user&.custom_role_id.present?
  end

  def permissions
    account_user&.permissions || []
  end

>>>>>>> upstream/develop
  def filter_by_permissions(permissions)
    # Permission-based filtering with hierarchy
    # conversation_manage > conversation_unassigned_manage > conversation_participating_manage
    if permissions.include?('conversation_manage')
<<<<<<< HEAD
      conversations
    elsif permissions.include?('conversation_unassigned_manage')
      filter_unassigned_and_mine
    elsif permissions.include?('conversation_participating_manage')
      conversations.assigned_to(user)
=======
      accessible_conversations
    elsif permissions.include?('conversation_unassigned_manage')
      filter_unassigned_and_mine
    elsif permissions.include?('conversation_participating_manage')
      accessible_conversations.assigned_to(user)
>>>>>>> upstream/develop
    else
      Conversation.none
    end
  end

  def filter_unassigned_and_mine
<<<<<<< HEAD
    mine = conversations.assigned_to(user)
    unassigned = conversations.unassigned
=======
    mine = accessible_conversations.assigned_to(user)
    unassigned = accessible_conversations.unassigned
>>>>>>> upstream/develop

    Conversation.from("(#{mine.to_sql} UNION #{unassigned.to_sql}) as conversations")
                .where(account_id: account.id)
  end
end
