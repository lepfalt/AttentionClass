class Response < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, undelivered: 3 }
  #belongs_to :user, class_name: "user", foreign_key: "user_id"
  #belongs_to :task, class_name: "task", foreign_key: "task_id"
  belongs_to :user, optional: false
  belongs_to :task, optional: false
end
