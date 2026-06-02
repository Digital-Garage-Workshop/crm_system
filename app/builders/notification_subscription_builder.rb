class NotificationSubscriptionBuilder
  pattr_initialize [:params, :user!]

  def perform
    move_subscription_to_user if identifier_subscription && identifier_subscription.user_id != user.id
    @previous_push_token = identifier_subscription&.subscription_attributes&.dig('push_token')

    subscription = identifier_subscription.blank? ? build_identifier_subscription : update_identifier_subscription
    replace_stale_fcm_subscriptions(subscription)
    subscription
  end

  private

  def identifier
    @identifier ||= params[:subscription_attributes][:endpoint] if params[:subscription_type] == 'browser_push'
    @identifier ||= params[:subscription_attributes][:device_id] if params[:subscription_type] == 'fcm'
    @identifier
  end

  def identifier_subscription
    @identifier_subscription ||= NotificationSubscription.find_by(identifier: identifier)
    @identifier_subscription ||= find_fcm_subscription_by_old_token if fcm_subscription?
    @identifier_subscription
  end

  def move_subscription_to_user
    @identifier_subscription.update(user_id: user.id)
  end

  def build_identifier_subscription
    @identifier_subscription = user.notification_subscriptions.create!(params.merge(identifier: identifier))
  end

  def update_identifier_subscription
    identifier_subscription.update!(params.merge(identifier: identifier))
    identifier_subscription
  end

  def fcm_subscription?
    params[:subscription_type] == 'fcm'
  end

  def find_fcm_subscription_by_old_token
    old_token = params[:subscription_attributes][:old_push_token]
    return if old_token.blank?

    user.notification_subscriptions
        .fcm
        .find_by(["subscription_attributes->>'push_token' = ?", old_token])
  end

  def replace_stale_fcm_subscriptions(subscription)
    return unless fcm_subscription?

    new_token = params[:subscription_attributes][:push_token]
    return if new_token.blank?

    tokens_to_remove = [params[:subscription_attributes][:old_push_token], @previous_push_token].compact.uniq
    tokens_to_remove -= [new_token]

    tokens_to_remove.each do |token|
      user.notification_subscriptions
          .fcm
          .where(["subscription_attributes->>'push_token' = ?", token])
          .where.not(id: subscription.id)
          .destroy_all
    end
  end
end
