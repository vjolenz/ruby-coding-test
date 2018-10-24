class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, unique: true
      t.string :first_name
      t.string :last_name
      t.integer :status, index: true

      t.timestamps
    end
  end
end
