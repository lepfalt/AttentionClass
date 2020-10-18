# frozen_string_literal: true

class AddActiveToResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :responses, :active, :boolean
  end
end
