class CreateTalentPoolApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :talent_pool_applications do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
