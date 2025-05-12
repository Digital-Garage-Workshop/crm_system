module Api
  module V1
    class NotificationSubscriptionsController < Api::BaseController
      before_action :fetch_user
      before_action :validate_params, only: [:create]

      def create
        # Find or initialize a subscription for the user and subscription type
        @notification_subscription = NotificationSubscription.find_or_initialize_by(
          user: @user,
          subscription_type: notification_subscription_params[:subscription_type]
        )

        # Assign subscription attributes
        @notification_subscription.subscription_attributes = notification_subscription_params[:subscription_attributes]

        if @notification_subscription.save
          render json: @notification_subscription, status: :ok
        else
          render json: { errors: @notification_subscription.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def fetch_user
        @user = Current.user
        return if @user.present?

        render json: { error: 'User not authenticated' }, status: :unauthorized
      end

      # Validate required parameters before processing
      def validate_params
        unless notification_subscription_params[:subscription_type].present? &&
               notification_subscription_params[:subscription_attributes].is_a?(Hash)
          render json: { error: 'Invalid parameters' }, status: :bad_request
        end
      end

      def notification_subscription_params
        params.require(:notification_subscription).permit(:subscription_type, subscription_attributes: {})
      end
    end
  end
end
