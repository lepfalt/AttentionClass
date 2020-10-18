# frozen_string_literal: true

class CreateClassGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :class_groups do |t|
      t.integer :responsible
      t.string :discipline
      t.string :class_code
      t.boolean :active
      t.date :expiration_date

      t.timestamps
    end
  end
end
