class AddEmailToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_column :recommendations, :email, :string
  end
end
