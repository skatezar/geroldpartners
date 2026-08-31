class Role < ApplicationRecord
  belongs_to :client
  has_many :recommendations, dependent: :nullify
  has_many :employers, dependent: :nullify

  validates :title, presence: true
end
