class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :password_digest, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :clients, :slug, unique: true
  end
end
