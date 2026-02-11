class AddExtendedDescriptionToMandates < ActiveRecord::Migration[7.2]
  def change
    add_column :mandates, :extended_description, :text
  end
end
