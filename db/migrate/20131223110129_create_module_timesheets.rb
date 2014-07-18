class CreateModuleTimesheets < ActiveRecord::Migration
  def change
    create_table :module_timesheets do |t|
      t.integer :project_module_id
      t.integer :timesheet_id

      t.timestamps
    end
  end
end
