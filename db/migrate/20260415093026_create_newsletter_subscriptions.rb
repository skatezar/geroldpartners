class CreateNewsletterSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email, null: false
      t.boolean :confirmed, default: false, null: false
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :newsletter_subscriptions, :email, unique: true
    add_index :newsletter_subscriptions, :confirmation_token, unique: true
    add_index :newsletter_subscriptions, :confirmed
  end
end
