class Captain::AssistantPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

<<<<<<< HEAD
=======
  def stats?
    true
  end

  def tools?
    @account_user.administrator?
  end

>>>>>>> upstream/develop
  def create?
    @account_user.administrator?
  end

  def update?
    @account_user.administrator?
  end

  def destroy?
    @account_user.administrator?
  end

<<<<<<< HEAD
=======
  def sync?
    @account_user.administrator?
  end

>>>>>>> upstream/develop
  def playground?
    true
  end
end
