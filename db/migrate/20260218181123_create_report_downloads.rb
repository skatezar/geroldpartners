class CreateReportDownloads < ActiveRecord::Migration[7.2]
  def change
    create_table :report_downloads do |t|
      t.references :compensation_report, null: false, foreign_key: true
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
