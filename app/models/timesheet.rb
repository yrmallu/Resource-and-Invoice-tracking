class Timesheet < ActiveRecord::Base
	belongs_to :project
    belongs_to :user
	has_many :tasks
	has_many :module_timesheets
	has_many :project_modules, :through => :module_timesheets
	accepts_nested_attributes_for :tasks, :allow_destroy=> true, :reject_if => :all_blank
end

