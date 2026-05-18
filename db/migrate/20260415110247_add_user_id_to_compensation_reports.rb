class AddUserIdToCompensationReports < ActiveRecord::Migration[7.2]
  def change
    add_reference :compensation_reports, :user, null: true, foreign_key: true
  end
end
