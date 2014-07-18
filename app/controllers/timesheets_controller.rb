class TimesheetsController < ApplicationController

 before_action :logged_in?
 before_action :get_task_types, :only=>[:add_timesheet, :check_timesheet_exist, :edit_task, :create_timesheet, :update_task, :archive_task]
 before_action :find_task, :only=>[:edit_task, :archive_task]
 before_action :get_all_tasks, :only=>[:archive_task]
 before_action :find_timesheet, :only=>[:archive_task, :edit_task]
 before_action :get_monthly_timesheet_details, :only=>[:get_monthly_timesheets, :get_logged_hours]
 before_action :get_team, :only=>[:add_timesheet]
 before_action :build_timesheet, :only=>[:create_timesheet, :update_task]
 
 def timesheet_params
    params.require(:timesheet).permit(:id, :user_id, :total_hours, :timesheet_date, :tasks_attributes=>[:id, :user_id, :project_id, :timesheet_id, :task_date, :name, :description, :hours, :delete_flag, :task_type_id])
 end
  
 def task_params
 	params.require(:task).permit(:id, :name, :description, :hours, :project_id, :user_id, :task_type_id)  
 end
 
 def get_task_types
 	@task_types = TaskType.all
 end
 
 def get_user_project
 	if params[:task_type_id] == "1"
		 @projects = params[:user_id].blank? ? current_user.projects : User.find(params[:user_id]).projects
	end
	unless params[:task_id].blank?
	@task = Task.where(:id => params[:task_id]).count == 0 ? '' : Task.find(params[:task_id])
	end
   	render :partial=>"get_user_project"
 end
 
 def get_monthly_timesheet_details
 	@clicked_year = params[:current_date].split("-").first unless params[:current_date].blank?
	@clicked_month = params[:current_date].split("-").second.to_i unless params[:current_date].blank?
	unless @clicked_month.blank?
   	   if(@clicked_month>0)
	       @clicked_month = @clicked_month - 1
   	   end
	end
 	
	@month_start_date = params[:current_date].blank? ? Time.now.to_date.beginning_of_month : params[:current_date].to_date.beginning_of_month
	@month_end_date = params[:current_date].blank? ? Time.now.to_date.end_of_month : params[:current_date].to_date.end_of_month
	@all_month_dates = (@month_start_date..@month_end_date).to_a 
	unless params[:user_id].blank?
		@all_timesheets = Timesheet.where("timesheet_date BETWEEN '#{@month_start_date}' AND '#{@month_end_date}' AND user_id = '#{params[:user_id]}'")
 	else
		@all_timesheets = Timesheet.where("timesheet_date BETWEEN '#{@month_start_date}' AND '#{@month_end_date}' AND user_id = '#{current_user.id}'")
	end
 end
 
 def add_timesheet
 end
 
 def build_task
 	@task = @timesheet.tasks.build
 end
 
 def get_monthly_timesheets
    render :partial=>"get_monthly_timesheets"
 end
 
 def get_logged_hours
 	@total_logged_hours = 0.0
	@all_timesheets
	unless @all_timesheets.blank?
		@all_timesheets.each do |timesheet|
			@total_logged_hours += timesheet.total_hours.to_f
		end
	else
		@total_logged_hours = params[:task_hours].to_f
	end
	render :partial=>"get_logged_hours"
 end
 
 def build_timesheet
   	@timesheet_exist = Timesheet.where("user_id= '#{params[:timesheet][:user_id]}' AND timesheet_date= '#{params[:timesheet][:timesheet_date]}' ").last
	@timesheet = @timesheet_exist.blank? ? Timesheet.create(:user_id=>params[:timesheet][:user_id], :timesheet_date=> params[:timesheet][:timesheet_date]) : @timesheet_exist
 	@new_task_hours = params[:timesheet][:task_hours].to_f
	@old_task_hours = params[:timesheet][:old_task_hours].to_f
 end
 
 def check_timesheet_exist
 	@timesheet_exist = Timesheet.where("user_id= '#{params[:user_id]}' AND timesheet_date= '#{params[:timesheet_date]}' ").last
	@timesheet = @timesheet_exist.blank? ? Timesheet.new(:user_id=>params[:user_id], :timesheet_date=> params[:timesheet_date]) : @timesheet_exist
	build_task
	@user_id = params[:user_id]
	render :partial=>"task_fields"
 end
 
 def create_timesheet
   	@new_task_hours = params[:timesheet][:task_hours].to_f
	@old_task_hours = params[:timesheet][:old_task_hours].to_f
	@timesheet_added = ""
	@current_timesheet_date = params[:timesheet_date].to_date
	@timesheet_hours = params[:timesheet][:task_hours].to_f
	
	if @timesheet.update(timesheet_params)
		change_logged_hours(params[:timesheet][:timesheet_date])
	 	@timesheet_added = true
		build_task
	else 
		flash[:error] = "Timesheet could not be added"
		redirect_to add_timesheet_timesheets_path
	end
 end
 
 def get_task_list
 	@timesheet = Timesheet.where("user_id= '#{params[:user_id]}' AND timesheet_date= '#{params[:timesheet_date]}' ").last
	@current_timesheet_date = params[:timesheet_date].to_date
	render :partial=>"task_list"
 end
 
 def edit_task
 	@is_edit = params[:is_edit] unless params[:is_edit].blank?
 end
 
 def update_task
 	@new_task_hours = params[:timesheet][:task_hours].to_f
	@old_task_hours = params[:timesheet][:old_task_hours].to_f
	
 	 @is_edit = params[:is_edit] unless params[:is_edit].blank?
	 @timesheet_updated = ""
	 @current_timesheet_date = params[:timesheet][:timesheet_date].to_date
	 @timesheet_hours = @timesheet.total_hours unless @timesheet.blank?
	  
	 if @timesheet.update(timesheet_params)
	 	change_logged_hours(params[:timesheet][:timesheet_date])
		@timesheet_updated = true
		build_task
     else
	     flash[:error] = "Timesheet could not be updated"
         redirect_to add_timesheet_timesheets_path
     end
 end
 
 def find_task
  	@task = Task.find(params[:task_id])
 end
 
 def find_timesheet
 	@timesheet = Timesheet.find(params[:timesheet_id])
 end
 
 def get_all_tasks
  	@tasks = Task.where("timesheet_id = #{params[:timesheet_id]}").order("created_at DESC")
 end
 
 def archive_task
 	@task_hours = @task.hours
	@timesheet.total_hours -= @task_hours
	@timesheet_hours = @timesheet.total_hours
	@timesheet.save
	@current_timesheet_date = params[:timesheet_date].to_date
    @task.destroy
 	build_task
	if @tasks.blank?
   	 	@timesheet.destroy
		
	end
 end

 def change_logged_hours(logged_date)
	@month_start_date = logged_date.blank? ? Time.now.to_date.beginning_of_month : logged_date.to_date.beginning_of_month
	@month_end_date = logged_date.blank? ? Time.now.to_date.end_of_month : logged_date.to_date.end_of_month
	@all_timesheets = Timesheet.where("timesheet_date BETWEEN '#{@month_start_date}' AND '#{@month_end_date}' AND user_id = '#{params[:timesheet][:user_id]}'")
 	@total_logged_hours = 0.0
	unless @all_timesheets.blank?
		@all_timesheets.each do |timesheet|
			@total_logged_hours += timesheet.total_hours.to_f
		end
	end
	@total_logged_hours = @total_logged_hours.to_f
 end
 
 def get_team
 	@team = []
	unless current_user.is_admin?
		current_user.projects.each do |project|
			project.project_contacts.each do |user|
				if project.user_id == current_user.id
					if user.user_type.eql?("employee") && user.is_verified
						@team << user.client_contact
					end
				else
				  if user.user_type.eql?("employee") && (project.user_id != user.user_id) && (user.is_verified) && (project.project_manager.id == current_user.id)
				       @team << user.client_contact
					end
				end
			end
		end
		current_user.team_members.each do |reporting_emp|
			@team << reporting_emp
		end
		@team << current_user
		@team = @team.uniq {|p| p.id}
	else
		@team = User.all.where("(user_type = \'employee\' OR is_admin = true) AND delete_flag is not true").order("created_at DESC")
	end
 end
 
 
end
