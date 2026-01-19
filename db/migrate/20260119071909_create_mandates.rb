class CreateMandates < ActiveRecord::Migration[7.2]
  def change
    create_table :mandates do |t|
      t.string :title
      t.text :description
      t.string :location
      t.string :firm_name
      t.string :firm_size
      t.boolean :active

      t.timestamps
    end
  end
end
