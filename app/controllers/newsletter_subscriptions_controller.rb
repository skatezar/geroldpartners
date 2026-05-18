class NewsletterSubscriptionsController < ApplicationController
  def create
    @subscription = NewsletterSubscription.new(subscription_params)

    if @subscription.save
      NewsletterMailer.confirmation_email(@subscription).deliver_now
      NewsletterMailer.admin_notification(@subscription).deliver_now
      render json: { success: true, message: 'Please check your email to confirm your subscription.' }
    else
      render json: { success: false, error: @subscription.errors.full_messages.join(', ') }
    end
  end

  def confirm
    @subscription = NewsletterSubscription.find_by(confirmation_token: params[:token])

    if @subscription && !@subscription.confirmed?
      @subscription.confirm!
      render 'confirm'
    elsif @subscription&.confirmed?
      @already_confirmed = true
      render 'confirm'
    else
      redirect_to root_path, alert: 'Invalid confirmation link.'
    end
  end

  private

  def subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
