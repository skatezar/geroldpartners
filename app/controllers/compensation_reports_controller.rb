class CompensationReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:download]

  def show
    @report = CompensationReport.find(params[:id])
  end

  def download
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
      email: email
    )

    if report_download.save
      CompensationReportMailer.report_downloaded(report_download).deliver_later

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
