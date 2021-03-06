class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :profile
      t.string :name
      t.string :registration
      t.string :email
      t.string :password
      t.string :password_digest

      t.timestamps
    end
  end
end
