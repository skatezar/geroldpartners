class CreateNewsletterSendRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_send_recipients do |t|
      t.references :newsletter_send, null: false, foreign_key: true
      t.string :email, null: false
      t.string :status, default: "pending", null: false
      t.string :error_message
      t.datetime :sent_at

      t.timestamps
    end
  end
end
