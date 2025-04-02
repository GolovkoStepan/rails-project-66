class CreateRepositories < ActiveRecord::Migration[7.2]
  def change
    create_table :repositories do |t|
      t.belongs_to 'user', null: false, foreign_key: true
      t.string 'name'
      t.integer 'github_id'
      t.string 'full_name'
      t.string 'language'
      t.string 'clone_url'
      t.string 'ssh_url'
      
      t.timestamps
    end
    
    add_index 'repositories', :github_id, unique: true
  end
end
