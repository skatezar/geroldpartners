class CreateApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :applications do |t|
      t.references :mandate, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :linkedin_url

      t.timestamps
    end
  end
end
