class RemoveDescriptionFromRecommendations < ActiveRecord::Migration[7.2]
  def change
    remove_column :recommendations, :description, :text
  end
end
