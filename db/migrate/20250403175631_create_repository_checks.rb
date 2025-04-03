class CreateRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_checks do |t|
      t.belongs_to :repository, null: false, foreign_key: true
      t.string :aasm_state, null: false
      t.boolean :passed, null: false, default: false
      t.integer :offenses_count, null: false, default: 0
      t.string :commit_id
      
      t.timestamps
    end
  end
end
