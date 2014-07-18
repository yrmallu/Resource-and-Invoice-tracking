class ModuleTimesheet < ActiveRecord::Base
	belongs_to :project_module
	belongs_to :timesheet
end
