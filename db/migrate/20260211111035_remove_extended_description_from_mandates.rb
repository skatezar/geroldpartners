class RemoveExtendedDescriptionFromMandates < ActiveRecord::Migration[7.2]
  def change
    remove_column :mandates, :extended_description, :text
  end
end
