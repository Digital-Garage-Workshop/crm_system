class Conversations::PermissionFilterService
  attr_reader :conversations, :user, :account

  def initialize(conversations, user, account)
    @conversations = conversations
    @user = user
    @account = account
  end

  def perform
<<<<<<< HEAD
    # The base implementation simply returns all conversations
    # Enterprise edition extends this with permission-based filtering
    conversations
=======
    return conversations if user_role == 'administrator'

    accessible_conversations
  end

  private

  def accessible_conversations
    conversations.where(inbox: user.inboxes.where(account_id: account.id))
  end

  def account_user
    AccountUser.find_by(account_id: account.id, user_id: user.id)
  end

  def user_role
    account_user&.role
>>>>>>> upstream/develop
  end
end

Conversations::PermissionFilterService.prepend_mod_with('Conversations::PermissionFilterService')
