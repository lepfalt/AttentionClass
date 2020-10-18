# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, ajusted: 3 }
  has_many :responses
  belongs_to :class_group, optional: false

  validates :title, :class_group_id, :description, :status, :expiration_date, presence: true
  # validates :status, inclusion: { in: [pending, progress, done, ajusted] }
  validates_associated :class_group # Ver
end
