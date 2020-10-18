# frozen_string_literal: true

class RenameClassId < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :class_id, :class_group_id
    rename_column :user_classes, :class_id, :class_group_id
  end
end
