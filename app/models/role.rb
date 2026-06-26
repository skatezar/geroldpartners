class Role < ApplicationRecord
  belongs_to :client
  has_many :recommendations, dependent: :nullify

  validates :title, presence: true
end
