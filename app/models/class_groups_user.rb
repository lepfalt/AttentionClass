class ClassGroupsUser < ApplicationRecord
  validates :user_id, :class_id, presence: true
  validates_associated :user
  validates_associated :class_group
end
