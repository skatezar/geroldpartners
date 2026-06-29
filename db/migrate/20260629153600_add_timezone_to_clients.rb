class AddTimezoneToClients < ActiveRecord::Migration[7.2]
  def change
    add_column :clients, :timezone, :string
  end
end
