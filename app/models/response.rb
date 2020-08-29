class Response < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, undelivered: 3 }
  belongs_to :user, optional: false
  belongs_to :task, optional: false

  validates :status, :user_id, :task_id, presence: true
  # validates :status, inclusion: { in: [pending, progress, done, undelivered] }
  # validates_associated :user
  # validates_associated :task
end
