class AddRoleToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_reference :recommendations, :role, null: true, foreign_key: true
  end
end
