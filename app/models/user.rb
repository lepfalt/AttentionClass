class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  has_many :responses
  has_and_belongs_to_many :class_groups
end
