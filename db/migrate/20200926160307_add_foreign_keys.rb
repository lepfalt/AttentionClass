class AddForeignKeys < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :tasks, :class_groups, column: 'class_group_id'
    add_foreign_key :responses, :users, column: 'user_id'
    add_foreign_key :responses, :tasks, column: 'task_id'
    add_foreign_key :class_groups, :users, column: 'user_id'
    add_foreign_key :class_groups_users, :users, column: 'user_id'
    add_foreign_key :class_groups_users, :class_groups, column: 'class_group_id'
  end
end
