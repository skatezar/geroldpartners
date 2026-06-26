class AddContactEmailsToClients < ActiveRecord::Migration[7.2]
  def change
    add_column :clients, :contact_emails, :string
  end
end
