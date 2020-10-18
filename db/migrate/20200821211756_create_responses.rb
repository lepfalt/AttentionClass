# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.integer :person_id
      t.integer :task_id
      t.text :response_value
      t.text :annotation_person
      t.integer :status
      t.float :grade
      t.text :observation_responsible

      t.timestamps
    end
  end
end
