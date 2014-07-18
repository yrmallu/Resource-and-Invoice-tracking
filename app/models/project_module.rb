class ProjectModule < ActiveRecord::Base
	belongs_to :project 
	validates :name, presence: true
	has_many :tasks
	has_many :module_timesheets
end
