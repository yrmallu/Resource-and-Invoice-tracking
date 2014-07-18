class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :file_name
      t.string :file_size

      t.timestamps
    end
  end
end
