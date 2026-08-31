class Employer < ApplicationRecord
  belongs_to :client
  belongs_to :role, optional: true

  validates :name, presence: true
end
