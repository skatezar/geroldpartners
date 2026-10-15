class CreateNewsletterSends < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_sends do |t|
      t.string :subject
      t.text :body
      t.string :template_name
      t.string :status, default: "draft", null: false
      t.integer :total_recipients, default: 0, null: false
      t.integer :sent_count, default: 0, null: false
      t.integer :failed_count, default: 0, null: false
      t.datetime :scheduled_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
