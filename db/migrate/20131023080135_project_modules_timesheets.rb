class ProjectModulesTimesheets < ActiveRecord::Migration
  
  def self.up
    create_table :project_modules_timesheets, :id => false do |t|
      t.integer :project_module_id
      t.integer :timesheet_id
    end
  end

  def self.down
    drop_table :project_modules_timesheets
  end
  
end
