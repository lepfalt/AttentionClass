class Response < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, undelivered: 3 }
  belongs_to :user, optional: false
  belongs_to :task, optional: false
  has_one_attached :response_value

  validates :status, :user_id, :task_id, presence: true
  # validates :status, inclusion: { in: [pending, progress, done, undelivered] }
  # validates_associated :user
  # validates_associated :task

  def self.isActive?(status, active)
    if status == 'undelivered'
      return false
    elsif status == 'done' && !active
      return false
    end

    return true
  end
end
