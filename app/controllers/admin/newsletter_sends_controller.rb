class Admin::NewsletterSendsController < ApplicationController
  include AdminAuthorizable

  before_action :set_send, only: [:show, :send_emails, :status]

  def index
    @sends = NewsletterSend.recent
    @subscribers = NewsletterSubscription.confirmed.order(:email).pluck(:email)
  end

  def create
    template = params[:template_name].presence || "blank"
    body = NewsletterTemplateHelper.body_for(template)

    @send = NewsletterSend.new(
      subject: params[:subject],
      template_name: template,
      body: body
    )

    emails = parse_emails(params[:recipient_emails])

    if @send.subject.blank?
      redirect_to admin_newsletter_sends_path, alert: "Subject is required." and return
    end

    if emails.empty?
      redirect_to admin_newsletter_sends_path, alert: "Add at least one recipient." and return
    end

    @send.total_recipients = emails.size
    @send.status = "draft"
    @send.save!

    emails.each do |email|
      @send.newsletter_send_recipients.create!(email: email, status: "pending")
    end

    redirect_to admin_newsletter_send_path(@send), notice: "Campaign created with #{emails.size} recipients."
  end

  def show
  end

  def send_emails
    unless @send.draft?
      redirect_to admin_newsletter_send_path(@send), alert: "Can only send a draft campaign." and return
    end

    @send.update!(status: "sending")
    NewsletterSendJob.perform_later(@send.id)

    redirect_to admin_newsletter_send_path(@send), notice: "Sending started — emails are going out in batches of 20 every 30 seconds."
  end

  def status
    render json: {
      status: @send.status,
      sent_count: @send.sent_count,
      failed_count: @send.failed_count,
      total_recipients: @send.total_recipients,
      progress_percent: @send.progress_percent
    }
  end

  private

  def set_send
    @send = NewsletterSend.find(params[:id])
  end

  def parse_emails(raw)
    return [] if raw.blank?
    raw.split(/[\s,;]+/).map(&:strip).map(&:downcase).select { |e| e.match?(URI::MailTo::EMAIL_REGEXP) }.uniq
  end
end
