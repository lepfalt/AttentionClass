class Task < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, ajusted: 3 }
  has_many :responses
  belongs_to :class_group, optional: false
end
