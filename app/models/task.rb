class Task < ApplicationRecord
  enum status: { pending: 0, progress: 1, done: 2, ajusted: 3 }
end
