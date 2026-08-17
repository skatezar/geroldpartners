class CompensationReportMailer < ApplicationMailer
  default from: 'contact@geroldpartners.com'

  def report_downloaded(report_download)
    @report_download = report_download
    @compensation_report = report_download.compensation_report

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: "Compensation Report Downloaded: #{@compensation_report.name}"
    )
  end
end
