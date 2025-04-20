class CreateRepositoryCheckOffenses < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_check_offenses do |t|
      t.belongs_to :check, null: false, foreign_key: { to_table: :repository_checks }
      t.string :file_path
      t.string :rule_name
      t.text :message
      t.integer :line
      t.integer :column
      
      t.timestamps
    end
  end
end
