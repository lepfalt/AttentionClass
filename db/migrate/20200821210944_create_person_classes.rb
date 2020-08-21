class CreatePersonClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :person_classes do |t|
      t.integer :person_code
      t.integer :class_code

      t.timestamps
    end
  end
end
