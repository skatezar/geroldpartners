class DropAdminsTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :admins if table_exists?(:admins)
  end

  def down
    create_table :admins do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps null: false
      t.index :email, unique: true
      t.index :reset_password_token, unique: true
    end
  end
end
