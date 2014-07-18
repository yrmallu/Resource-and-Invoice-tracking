class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :project_module_id
      t.integer :timesheet_id
      t.date :task_date
      t.text :description
      t.float :hours
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
