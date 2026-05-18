class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mandates, dependent: :nullify
  has_many :compensation_reports, dependent: :nullify

  def admin?
    admin
  end
end
