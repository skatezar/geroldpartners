class AddCandidateDetailsToRecommendations < ActiveRecord::Migration[7.2]
  def change
    add_column :recommendations, :compensation_expectation, :string
    add_column :recommendations, :visa_requirement, :string
    add_column :recommendations, :earliest_start, :string
  end
end
