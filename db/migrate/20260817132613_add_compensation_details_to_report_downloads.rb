class AddCompensationDetailsToReportDownloads < ActiveRecord::Migration[7.2]
  def change
    add_column :report_downloads, :compensation_details, :text
  end
end
