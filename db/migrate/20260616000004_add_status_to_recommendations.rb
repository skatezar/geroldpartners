class AddStatusToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_column :recommendations, :status, :string, null: false, default: "not_interviewed"
    add_index :recommendations, :status
  end
end
