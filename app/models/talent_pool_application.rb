class TalentPoolApplication < ApplicationRecord
  has_one_attached :cv

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
