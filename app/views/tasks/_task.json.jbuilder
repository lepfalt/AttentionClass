json.extract! task, :id, :title, :class_code, :description, :status, :expiration_date, :active, :created_at, :updated_at
json.url task_url(task, format: :json)
