class User < ApplicationRecord
  has_many :responses
  #belongs_to :class_group
  has_many :class_groups_users
  has_secure_password

  enum profile: { standard: 0, admin: 1 }
  validates :profile, inclusion: { in: [standard, admin] }

  VALID_EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i.freeze
  # pesquisar solução depois
  validates :email, presence: true, length: {maximum: 260}, format: { with: VALID_EMAIL_FORMAT}, uniqueness: {case_sensitive: false}
  validates :password, :profile, :name, presence: true
end
