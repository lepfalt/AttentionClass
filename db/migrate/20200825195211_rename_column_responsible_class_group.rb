class RenameColumnResponsibleClassGroup < ActiveRecord::Migration[6.0]
  def change
    rename_column :class_groups, :responsible, :user_id
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
