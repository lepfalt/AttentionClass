class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :class_code
      t.text :description
      t.integer :status
      t.date :expiration_date
      t.boolean :active

      t.timestamps
    end
  end
end
