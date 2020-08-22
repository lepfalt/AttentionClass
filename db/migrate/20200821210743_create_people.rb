class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.integer :profile
      t.string :name
      t.string :registration
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
