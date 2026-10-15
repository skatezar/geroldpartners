class AddAddedByAdminToNewsletterSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_column :newsletter_subscriptions, :added_by_admin, :boolean, default: false, null: false
  end
end
