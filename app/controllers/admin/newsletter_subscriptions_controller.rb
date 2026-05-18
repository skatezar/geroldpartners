class Admin::NewsletterSubscriptionsController < ApplicationController
  include AdminAuthorizable

  def index
    @subscriptions = NewsletterSubscription.order(created_at: :desc)
    @confirmed_count = @subscriptions.confirmed.count
    @unconfirmed_count = @subscriptions.unconfirmed.count
  end
end
