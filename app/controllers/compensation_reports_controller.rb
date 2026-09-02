class CompensationReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:download]

  def show
    @report = CompensationReport.find(params[:id])
  end

  def download
    if bot_submission? || rate_limited?("comp_report", limit: 10)
      render json: { success: false, errors: ["Too many requests. Please try again later."] }, status: :too_many_requests
      return
    end

    report_id = params[:report_id]
    name = params[:name]
    email = params[:email]
    newsletter = params[:newsletter]

    if report_id.blank? || name.blank? || email.blank?
      render json: { success: false, errors: ['All fields are required'] }, status: :unprocessable_entity
      return
    end

    compensation_report = CompensationReport.find_by(id: report_id)

    if compensation_report.nil?
      render json: { success: false, errors: ['Report not found'] }, status: :not_found
      return
    end

    report_download = ReportDownload.new(
      compensation_report: compensation_report,
      name: name,
      email: email,
      compensation_details: params[:compensation_details].presence
    )

    if report_download.save
      CompensationReportMailer.report_downloaded(report_download).deliver_later
      CompensationReportMailer.report_sent(report_download).deliver_now

      if newsletter
        subscription = NewsletterSubscription.find_or_initialize_by(email: email.downcase)
        unless subscription.confirmed?
          subscription.save
          NewsletterMailer.confirmation_email(subscription).deliver_later
        end
      end

      render json: { success: true }
    else
      render json: { success: false, errors: report_download.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
