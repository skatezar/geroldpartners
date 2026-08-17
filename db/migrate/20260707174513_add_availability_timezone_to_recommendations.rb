class AddAvailabilityTimezoneToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_column :recommendations, :availability_timezone, :string
  end
end
