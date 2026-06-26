class AddPreviewTokenToClients < ActiveRecord::Migration[7.2]
  def change
    add_column :clients, :preview_token, :string
    add_index :clients, :preview_token
  end
end
