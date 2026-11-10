require 'net/http'
require 'json'

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def bot_submission?
    params[:website_url].present?
  end

  def rate_limited?(key, limit: 10, window: 1.hour)
    cache_key = "rate_limit_#{key}_#{request.remote_ip}"
    count = Rails.cache.read(cache_key) || 0
    return true if count >= limit
    Rails.cache.write(cache_key, count + 1, expires_in: window)
    false
  end

  def verify_turnstile?
    return true if Rails.env.development? && request.host == 'localhost'

    token = params['cf-turnstile-response']
    return false if token.blank?

    secret_key = ENV['CLOUDFLARE_TURNSTILE_SECRET_KEY']
    return true if secret_key.blank?

    uri = URI('https://challenges.cloudflare.com/turnstile/v0/siteverify')
    response = Net::HTTP.post_form(uri, {
      'secret' => secret_key,
      'response' => token,
      'remoteip' => request.remote_ip
    })

    result = JSON.parse(response.body)
    result['success']
  rescue => e
    Rails.logger.error "Turnstile verification error: #{e.message}"
    false
  end

  def current_user
    return @_resolved_current_user if defined?(@_resolved_current_user)
    devise_user =
      begin
        warden.authenticate(scope: :user)
      rescue ArgumentError
        warden.logout(:user)
        nil
      end
    @_resolved_current_user =
      if devise_user.nil?
        nil
      elsif devise_user.is_a?(Hash)
        User.find(devise_user['id'] || devise_user[:id])
      else
        devise_user
      end
  end
  helper_method :current_user
end
