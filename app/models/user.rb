class User < ApplicationRecord
  has_many :grading_standards
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50},
                                    format: { with: VALID_EMAIL_REGEX},
                                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true
end
