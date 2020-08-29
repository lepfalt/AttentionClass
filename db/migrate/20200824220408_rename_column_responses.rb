class RenameColumnResponses < ActiveRecord::Migration[6.0]
  def change
    rename_column :responses, :person_id, :user_id
    rename_column :responses, :annotation_person, :response_annotation
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
