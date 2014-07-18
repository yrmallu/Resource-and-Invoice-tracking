class RemoveProjectModuleIdFromTimesheets < ActiveRecord::Migration
  def change
    remove_column :timesheets, :project_module_id, :integer
  end
end
