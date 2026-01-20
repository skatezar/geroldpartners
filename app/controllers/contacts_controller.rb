require 'net/http'
require 'json'

class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)

    # Validate Cloudflare Turnstile
    unless verify_turnstile?
      Rails.logger.warn "Bot submission blocked - Turnstile failed: #{request.remote_ip}"
      render json: { success: false, errors: ["Please complete the CAPTCHA verification."] }, status: :unprocessable_entity
      return
    end

    # Validate honeypot
    unless params.dig(:contact, :website).blank?
      Rails.logger.warn "Bot submission blocked - honeypot triggered: #{request.remote_ip}"
      render json: { success: false, errors: ["Please complete the security check correctly."] }, status: :unprocessable_entity
      return
    end

    # Time-based validation
    form_timestamp = params[:form_timestamp].to_i
    if form_timestamp > 0
      time_spent = Time.now.to_i - form_timestamp
      if time_spent < 3
        Rails.logger.warn "Bot submission blocked - too fast: #{request.remote_ip}"
        render json: { success: false, errors: ["Please complete the security check correctly."] }, status: :unprocessable_entity
        return
      end
    end

    # Rate limiting
    unless within_rate_limit?
      Rails.logger.warn "Rate limit exceeded: #{request.remote_ip}"
      render json: { success: false, errors: ["Too many submissions. Please try again later."] }, status: :too_many_requests
      return
    end

    if @contact.save
      # Send email notification
      ContactMailer.new_contact(@contact).deliver_now

      render json: { success: true, message: "Message sent successfully" }, status: :ok
    else
      render json: { success: false, errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end

  def within_rate_limit?
    cache_key = "contact_form_#{request.remote_ip}"
    submissions = Rails.cache.read(cache_key) || 0

    return false if submissions >= 10

    Rails.cache.write(cache_key, submissions + 1, expires_in: 1.hour)
    true
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
end
