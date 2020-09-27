class ClassGroup < ApplicationRecord
  has_many :tasks
  has_many :class_groups_users
  belongs_to :user, optional: false # Verificar depois

  validates :discipline, presence: true
  validates :expiration_date, presence: true
end
