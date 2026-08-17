class CompensationReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:download]

  def download
    report_id = params[:report_id]
    name = params[:name]
    email = params[:email]
    compensation_details = params[:compensation_details]

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
      compensation_details: compensation_details.presence
    )

    if report_download.save
      CompensationReportMailer.report_downloaded(report_download).deliver_later
      render json: { success: true }
    else
      render json: { success: false, errors: report_download.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
