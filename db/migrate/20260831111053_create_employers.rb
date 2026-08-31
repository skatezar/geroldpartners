class CreateEmployers < ActiveRecord::Migration[7.2]
  def change
    create_table :employers do |t|
      t.string :name
      t.string :website
      t.text :notes
      t.references :client, null: false, foreign_key: true
      t.references :role, null: true, foreign_key: true

      t.timestamps
    end
  end
end
