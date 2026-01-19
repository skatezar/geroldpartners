class Mandate < ApplicationRecord
  has_many :job_applications, class_name: 'JobApplication', dependent: :destroy

  validates :title, :description, :location, presence: true

  scope :active, -> { where(active: true) }
end
