# frozen_string_literal: true

class DestroyUserClasses < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_classes do |t|
      t.integer :user_id
      t.integer :class_id

      t.timestamps
    end
  end
end
