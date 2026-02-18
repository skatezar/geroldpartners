class CompensationReport < ApplicationRecord
  has_one_attached :pdf
  has_many :report_downloads, dependent: :destroy

  validates :name, :location, presence: true
  validates :pdf, presence: true
end
