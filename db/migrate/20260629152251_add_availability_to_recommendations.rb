class AddAvailabilityToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_column :recommendations, :availability_token, :string
    add_index :recommendations, :availability_token, unique: true
    add_column :recommendations, :availability_slots, :text
    add_column :recommendations, :availability_submitted_at, :datetime
  end
end
