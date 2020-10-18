# frozen_string_literal: true

json.extract! response, :id, :person_id, :task_id, :response_value, :annotation_person, :status, :grade, :observation_responsible, :created_at, :updated_at
json.url response_url(response, format: :json)
