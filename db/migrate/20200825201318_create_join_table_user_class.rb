# frozen_string_literal: true

class CreateJoinTableUserClass < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :class_groups
  end
end
