class CreateRecommendations < ActiveRecord::Migration[7.2]
  def change
    create_table :recommendations do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.string :linkedin_url
      t.text :description

      t.timestamps
    end
  end
end
