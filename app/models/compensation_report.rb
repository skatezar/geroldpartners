class CompensationReport < ApplicationRecord
  has_one_attached :pdf

  validates :name, :location, presence: true
  validates :pdf, presence: true
end
