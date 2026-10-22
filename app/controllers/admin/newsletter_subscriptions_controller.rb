class Admin::NewsletterSubscriptionsController < ApplicationController
  include AdminAuthorizable

  def index
    @subscriptions = NewsletterSubscription.order(created_at: :desc)
    @confirmed_count = @subscriptions.confirmed.count
    @unconfirmed_count = @subscriptions.unconfirmed.count
    @admin_added_count = @subscriptions.admin_added.count
    @new_subscription = NewsletterSubscription.new
  end

  def create
    @new_subscription = NewsletterSubscription.new(email: params.dig(:newsletter_subscription, :email)&.strip&.downcase)
    @new_subscription.added_by_admin = true
    @new_subscription.confirmed = true
    @new_subscription.confirmed_at = Time.current

    if @new_subscription.save
      redirect_to admin_newsletter_subscriptions_path, notice: "#{@new_subscription.email} added successfully."
    else
      @subscriptions = NewsletterSubscription.order(created_at: :desc)
      @confirmed_count = @subscriptions.confirmed.count
      @unconfirmed_count = @subscriptions.unconfirmed.count
      @admin_added_count = @subscriptions.admin_added.count
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    subscription = NewsletterSubscription.find(params[:id])
    email = subscription.email
    subscription.destroy
    redirect_to admin_newsletter_subscriptions_path, notice: "#{email} removed from newsletter."
  end
end
