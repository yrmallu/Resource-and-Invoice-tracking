class Task < ActiveRecord::Base
	belongs_to :project_module
	belongs_to :timesheet
	belongs_to :task_type
    belongs_to :project
	belongs_to :user

before_save :get_total_hours_task
	
 def get_total_hours_task
 	unless self.timesheet.total_hours.nil?
		self.timesheet.total_hours = (self.timesheet.total_hours - self.hours_was.to_f ) + self.hours.to_f
		self.timesheet.save
	else
		self.timesheet.total_hours = '0.0'.to_f
		self.timesheet.total_hours += self.hours.to_f
		self.timesheet.save
	end
 end

end