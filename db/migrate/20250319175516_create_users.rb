class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :nickname
      t.string :image_url
      t.string :token
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
  end
end
