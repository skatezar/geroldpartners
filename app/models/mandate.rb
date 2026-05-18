class Mandate < ApplicationRecord
  belongs_to :user, optional: true
  has_many :job_applications, class_name: 'JobApplication', dependent: :destroy
  has_rich_text :extended_description

  validates :title, :description, :location, presence: true

  scope :active, -> { where(active: true) }
end
