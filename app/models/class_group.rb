class ClassGroup < ApplicationRecord
  has_many :tasks
  has_and_belongs_to_many :users
  belongs_to :user, optional: false
end
