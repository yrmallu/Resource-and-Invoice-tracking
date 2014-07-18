class CreateProjectModules < ActiveRecord::Migration
  def change
    create_table :project_modules do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :name
      t.text :description
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
