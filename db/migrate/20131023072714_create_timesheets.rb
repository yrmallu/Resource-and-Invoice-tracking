class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :title
      t.integer :project_module_id
      t.float :total_hours
      t.date :timesheet_date
      t.text :description
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
