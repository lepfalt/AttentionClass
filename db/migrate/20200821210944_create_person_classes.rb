class CreatePersonClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :person_classes do |t|
      t.integer :person_id
      t.integer :class_id

      t.timestamps
    end
  end
end
