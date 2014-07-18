class ProjectsController < ApplicationController
  before_action :logged_in?


  before_action :set_company, :only => [:new, :edit, :index, :create, :show, :update, :project, :project_members, :time_material_milestone, :fixed_cost_payment, :fc_milestone, :tm_milestone, :get_new_tm_milestone, :assign_project_members, :invite_project_team, :list_project_managers, :time_material_payment, :get_all_project, :get_tm_milestone, :get_milestone, :get_new_fc_milestone, :get_all_project, :list_project_modules, :edit_project_module, :update_project_module, :employee_type]
  before_action :get_client, :only => [:new, :edit, :create, :update, :index]
  before_action :get_user, :only => [:new, :edit, :create, :update, :assign_project_members ]
  before_action :set_project, :only=>[:show, :edit, :update, :destroy, :project_members, :assign_project_members, :show_project_members]
  before_action :get_project, :only=>[:index, :project_members, :new, :edit]
  before_action :project_members, :only=>[:show]
  before_action :find_project, :only=>[:project_module, :show_project_module, :project_module_create, :list_project_modules, :edit_project_module, :update_project_module ]
  before_action :edit_project_module, :only=>[:archive_project_module, :show_project_module ]
  before_action :employee_type, :only=>[:project_members, :invite_project_team, :cancel_project_invitation, :cancel_invited_project_invitation]
  before_action :delete_project_member, :only=>[:cancel_project_invitation, :cancel_invited_project_invitation]
  before_action :build_milestones, :only=>[:get_milestone, :get_tm_milestone]
  before_action :build_new_milestone, :only=>[:get_new_fc_milestone, :get_new_tm_milestone]
  before_action :remove_milestones, :only=>[:delete_milestone, :delete_tm_milestone]
  
  load_and_authorize_resource :only=>[:show, :new, :edit, :destroy, :index]
  
  def new
    @project = Project.new
    @project_files = @project.project_files.build
  end
  
  def index
  	@users = @company.users.where("delete_flag is not true and user_type='employee'")
	arrayUserIds = @users.map(&:id) 
	@arrayProjectManagers =[]
	@projects = Project.where("user_id IN ('#{arrayUserIds.join("','")}')  AND delete_flag is not true ").order("created_at DESC")
	@projects.each do |project|
		@arrayProjectManagers<<project.project_manager
	end
	@arrayProjectManagers.uniq
  end
  
  def create
    @project = Project.new(project_params)
    path = request.env['HTTP_HOST']
	if @project.save
      @project.create_activity :create, owner: current_user
      @project.contact_persons(params[:contact_persons])
	  unless params[:project][:user_id].blank?
	  	@project.project_contacts.create(:user_id=> "#{params[:project][:user_id]}", :user_type=>'employee',:is_verified=> '1')
	  end
	  user = User.find(params[:project][:user_id])
	  @project.project_created_mail(user, path, action="create")
	  flash[:success] = "Project created"
      #redirect_to projects_path
	  last_project_save_id = Project.last.id
	  if "fixed_cost".eql?(params[:project_type])
	  	redirect_to tm_project_detail_users_path(:id=>last_project_save_id)
      else
	  	redirect_to project_detail_users_path(:id=>last_project_save_id)
	  end
	else 
      render :action=> 'new'
    end
  end
  
  def show
  	get_all_started_projects
  	@contact_point = @project.client_contacts.where("project_contacts.user_type = \'contact_point\'")
  end
  
  def edit
    @project_file = Project.find(params[:id])
    @project_files = @project.project_files.build
  end
  
  def update
    if @project.update(project_params)
      @project.create_activity :update, owner: current_user
      @project.contact_persons(params[:contact_persons])
	  path = request.env['HTTP_HOST']
	  user = User.find(params[:project][:user_id])
	  @project.project_created_mail(user, path, action="")
	  flash[:success] = "Project details updated"
	  redirect_to projects_path
    else
      render :action=>"edit"
    end
  end
  
  def destroy
    @project.update_attributes(:delete_flag=>true)
    @project.create_activity :archived, owner: current_user
	flash[:success] = "Project archived"
    redirect_to projects_url
  end
  
  def get_all_started_projects   
  	@projects = @company.projects.where("status in ('started') and delete_flag is not true").order("created_at DESC")
  end
  
  def detele_project_file
    @project_file = Project.find(params[:id])
    @project_upload = ProjectFile.find(params[:file_id])
    @project_upload.destroy
  	respond_to do |format|
 		format.html {
 			 
 	 	}
 		format.js{}
  	end
  end
  
  def get_client_contact_point
    @project = Project.find(params[:id]) unless params[:id].blank?
    client = Client.find(params[:client_id])
    @contact_points = client.contact_points.where("delete_flag is not true").order("created_at desc")
    render :partial=>"client_contact_point"
  end
  
  def project
  	respond_to do |format|
		
		format.js{
		
			arrayConditions = Array.new
			
			# check if user has entered title in textfield
			arrayConditions << 'title like ' + "'%" + params[:project_title]+ "%'" unless(params[:project_title].blank?)
			
			# check if user has selected project manager in dropdown
			arrayConditions << 'user_id = ' +"'" + params[:proj_manager_id]+ "'" unless(params[:proj_manager_id].blank?)
				
			# check if user has selected project type in dropdown
			projectTypeValue = 'Fixed Cost'.eql?(params[:proj_type]) ? 'fixed_cost' : 't_and_m' 
			arrayConditions << 'project_type =' + "'" + projectTypeValue + "'" unless(params[:proj_type].blank?)
			
			# check if user has selected client in dropdown
			arrayConditions << 'client_id =' + "'" + params[:client_id] + "'" unless(params[:client_id].blank?)
			
			if ( !params[:proj_start_date_value].blank? && !params[:proj_end_date_value].blank?)
				# check if user has selected project duration start and end dates in datepicker
				arrayConditions << "(start_date >='" + params[:proj_start_date_value] + "' AND end_date <='" + params[:proj_end_date_value] + "')" unless(params[:proj_start_date_value].blank? || params[:proj_end_date_value].blank?)
			elsif (params[:proj_start_date_value].blank? && !params[:proj_end_date_value].blank?)
				# check if user has selected project duration end date in datepicker
				arrayConditions << "(end_date ='" + params[:proj_end_date_value] + "')" unless(params[:proj_end_date_value].blank?)
			elsif ( !params[:proj_start_date_value].blank? && params[:proj_end_date_value].blank?)
				# check if user has selected project duration start date in datepicker
				arrayConditions << "(start_date ='" + params[:proj_start_date_value] + "')" unless(params[:proj_start_date_value].blank?)
			end
						
			arrayConditions << "delete_flag is not true"
			# join all the conditions with AND condition
			# also search all employees to a specific company
			p strConditions = arrayConditions.join(' AND ') unless arrayConditions.empty?
			@projects = @company.projects.where(strConditions)
			}
  	end
  end
  
  def download_file
    @project_file = ProjectFile.find(params[:id])
    send_file('http://192.168.10.125:3001/project/images/16/original/ws_loader.gif',:disposition=>'attachment', :filename => @project_file.files_file_name,:type=>@project_file.files_content_type)
  end
  
  def fixed_cost_payment
    @project = Project.find(params[:id])
    @fixed_cost = @project.fixed_costs
	get_all_started_projects
  end
  
  def time_material_milestone
    @project = Project.find(params[:id])
    @time_material = @project.timematerial_milestones
	get_all_started_projects
  end
  
  def time_material_payment
  	get_all_started_projects
  	@project = Project.find(params[:id])
    # Only project related verified users list
	@users = []
	@all_users = @project.project_contacts
	@all_users.each do |user|
		unless user.is_verified.eql?('true') || !user.user_type.eql?('employee')
			@users << user.client_contact
		end
	end
	@time_materials = @project.time_materials.blank? ? @project.time_materials.build : @project.time_materials
  end
  
  def fc_payment_create
	
    @fc_project = Project.find(params[:id])
    if @fc_project.update(fc_project_params)
	  flash[:success] = "Project milestone details created/updated"
     # redirect_to projects_url
	  redirect_to fixed_cost_payment_projects_path(:id=>@fc_project)
    else
      render :action=>"fixed_cost_payment"
    end
  end
  
  def tm_payment_create
  
    @project = Project.find(params[:id])
    if @project.update(tm_project_params)
	  flash[:success] = "Project milestones created/updated"
      redirect_to time_material_payment_projects_path(:id=>@project)
    else
      render :action=>"time_material_payment"
    end
  end
  
  def fc_milestone
    @project = Project.includes(:fixed_costs).where("id = #{params[:id]}").last
	get_all_started_projects
  end
  
  def tm_milestone_create
   @tm_project = Project.find(params[:id])
    if @tm_project.update(tm_milestone_params)
	  flash[:success] = "Project milestone details created/updated"
   	  redirect_to time_material_milestone_projects_path(:id=>@tm_project)
    else
      render :action=>"fixed_cost_payment"
    end
  end
  
  def tm_milestone
    @project = Project.includes(:timematerial_milestones).where("id = #{params[:id]}").last
	get_all_started_projects
  end
  
  def get_fc_detail
    @fixed_cost = FixedCost.find(params[:id])
    render :partial=>"get_fc_milestone"
  end
  
  def get_tm_detail
    @time_material = TimematerialMilestone.find(params[:id])
    render :partial=>"get_tm_milestone"
  end
  
  def update_fc_milestone
    @fixed_cost = FixedCost.includes(:project).where("id = #{params[:id]}").last
    @project = @fixed_cost.project
    pre_end_date = @fixed_cost.milestone_end_date
    @fixed_cost.update(fc_milestone_params)
    @fixed_cost.update_milestone_date(params[:change_flag],pre_end_date) unless params[:change_flag].blank?
    respond_to do |format|
      format.html {}
      format.js{}
    end
  end
  
  def update_tm_milestone
    @time_material = TimematerialMilestone.includes(:project).where("id = #{params[:id]}").last
    @project = @time_material.project
    pre_end_date = @time_material.milestone_end_date
    @time_material.update(tm_milestone_delay_params)
    @time_material.update_milestone_date(params[:change_flag],pre_end_date) unless params[:change_flag].blank?
    respond_to do |format|
      format.html {}
      format.js{}
    end
  end
  
  def fc_raise_invoice
  	@fixed_cost = FixedCost.find(params[:id])
    @fixed_cost.update_attributes(:status=>params[:status])
    respond_to do |format|
      format.html {}
      format.js{}
    end
  end
  
  def tm_raise_invoice
  	@time_material = TimematerialMilestone.find(params[:id])
    @time_material.update_attributes(:status=>params[:status])
    respond_to do |format|
      format.html {}
      format.js{}
    end
  end
  
  def remove_milestones
    @project = Project.find(params[:id])
	@new_milestone_count = params[:milestone_count]
	@project.update("no_of_milestones"=>@new_milestone_count)
  end
  
  def delete_milestone
    @fixed_cost = FixedCost.find(params[:milestone_id])
    render :json=> {:status=>true}.to_json and return @fixed_cost.destroy if @fixed_cost
    render :json=> {:status=>false}.to_json and return
  end
  
  def delete_tm_milestone
    @time_material = TimematerialMilestone.find(params[:milestone_id])
    render :json=> {:status=>true}.to_json and return @time_material.destroy if @time_material
    render :json=> {:status=>false}.to_json and return
  end
  
  def build_milestones
    @milestones =[]
    @start = []
    @ending = []
    starting_date = params[:starting_date].blank? ? Time.now.to_date : params[:starting_date].to_date
	if starting_date.saturday? 
		starting_date +=2
	elsif starting_date.sunday? 
		starting_date +=1
	end
    holidays = @company.public_holidays.map(&:holiday_date)
    temp = check_holiday(starting_date, holidays)
    params[:milestones].to_i.times do |x|
      @start << temp
      days_count = (temp...2.weeks.since((temp)).to_date).count {|day| !day.saturday? && !day.sunday? && !holidays.include?(day)}
      e_date = (days_count <= 14) ? (temp + (15+(14-days_count)).days) : (temp + days_count.days)
  		if e_date.saturday? 
  			e_date +=2
  		elsif e_date.sunday? 
  			e_date +=1
  		end
      @ending << check_holiday(e_date, holidays)
      temp = check_holiday((check_holiday(e_date, holidays) + 1.days), holidays)
    end
    @project = Project.find(params[:id])
    @milestone_amount = (params[:remain_amount].to_f/params[:milestones].to_i).round(2)
  end
  
  def get_milestone
    params[:milestones].to_i.times{ |x| @milestones << @project.fixed_costs.build(:milestone_name=>"M"+(x+1).to_s, :amount=>@milestone_amount, :milestone_start_date=>@start[x], :milestone_end_date=>@ending[x])}
    render :partial=>"fc_project"
  end
  
  def get_tm_milestone
    params[:milestones].to_i.times{ |x| @milestones << @project.timematerial_milestones.build(:milestone_name=>"M"+(x+1).to_s, :amount=>@milestone_amount, :milestone_start_date=>@start[x], :milestone_end_date=>@ending[x])}
    render :partial=>"tm_project"
  end
  
  def build_new_milestone
  	@project = Project.find(params[:id])
    @start = []
    @ending = []
	@milestones =[]
    holidays = @company.public_holidays.map(&:holiday_date)
    if "fixed_cost".eql?(@project.project_type)
		starting_date = check_holiday(@project.fixed_costs.last.milestone_end_date+1 , holidays)
	else
		starting_date = check_holiday(@project.timematerial_milestones.last.milestone_end_date+1 , holidays)
	end
	if starting_date.saturday? 
		starting_date +=2
	elsif starting_date.sunday? 
		starting_date +=1
	end
    temp = check_holiday(starting_date, holidays)
	@start << temp
    days_count= (temp...2.weeks.since((temp)).to_date).count {|day| !day.saturday? && !day.sunday? && !holidays.include?(day)}
    e_date = (days_count <= 14) ? (temp + (13+(14-days_count)).days) : (temp + days_count.days)
  	if e_date.saturday? 
  		e_date +=2
  	elsif e_date.sunday? 
  		e_date +=1
  	end
	@ending << check_holiday(e_date, holidays)
  end
  
  def get_new_fc_milestone
  	1.times{ |x| @milestones << @project.fixed_costs.build(:milestone_name=>"M"+(@project.fixed_costs.count+1).to_s, :milestone_start_date=>@start[x], :milestone_end_date=>@ending[x])}
  	render :partial=>"fc_project"
  end
  
  def get_new_tm_milestone
  	1.times{ |x| @milestones << @project.timematerial_milestones.build(:milestone_name=>"M"+(@project.timematerial_milestones.count+1).to_s, :milestone_start_date=>@start[x], :milestone_end_date=>@ending[x])}
    render :partial=>"tm_project"
  end
  
  def check_holiday(date, holidays)
    temp = date
    for i in (0..holidays.length)
      if holidays.include?(temp)
        temp += 1.days
      else
        return temp
      end
    end
  end
  

  def delete_time_material
    @time_material = TimeMaterial.find(params[:fc_id])
    
    render :json=> {:status=>true}.to_json and return @time_material.destroy if @time_material
    render :json=> {:status=>false}.to_json and return
  end
  
  def project_members	
  	 @users = @company.users.includes(:role).where("delete_flag is not true and user_type = 'employee'")
  end
  
  def assign_project_members
  	team_member_id = params[:team_member_id]
    unless team_member_id.blank?
    	project_contacts = @project.client_contacts.blank? ? [] : @project.client_contacts.where("project_contacts.user_type = \'employee\'").collect!{|i| i.id.to_s}
      	unless (team_member_id.reject {|x| x.empty?} - project_contacts).blank?
        	new_contacts = User.where("id IN (#{(team_member_id.reject {|x| x.empty?} - project_contacts).join(',')})")
        	new_contacts.each do |x|   
				@project.project_contacts.create(:user_id=> x.id, :user_type=>'employee')
	  			proj_info = {:email => x.email, :proj_name => @project.title, :url =>  "http://"+request.env['HTTP_HOST'] } 
	  			UserMailer.project_invite_email(proj_info).deliver
			end 
      	end
      	unless (project_contacts - team_member_id.reject {|x| x.empty?}).blank?
        	remove_contacts = User.where("id IN (#{(project_contacts - team_member_id.reject {|x| x.empty?}).join(',')})")
        	remove_contacts.each{|x| @project.client_contacts.delete(x)} unless remove_contacts.blank?
      	end
		redirect_to @project, :notice=> 'Project members were successfully assigned and invites sent.'
    else
		redirect_to project_members_projects_path(:id=>params[:id]), :notice=> 'Please select project members'
	  end
  end
  
  def project_module
  	@project_modules = @project.project_modules.build
  end
  
  def project_module_create
  	if @project.update(project_module_params)
   		redirect_to list_project_modules_projects_path(:id=>params[:id]), :notice=> 'Project Module was successfully created.'
 	else 
   		render :action=>"project_module"
 	end
  end
  
  def list_project_modules
  	@modules = @project.project_modules.where("delete_flag is not true").order("created_at DESC").page(params[:page]).per(15)
  end
  
  def edit_project_module
    @project_module = ProjectModule.find("#{params[:mod_id]}")
  end
  
  def update_project_module
    if @project.update(project_module_params)
      redirect_to list_project_modules_projects_path(:id=>params[:id]), :notice=> 'Project module was successfully updated.'
    else
      render :action=>"project_module"
    end
  end
  
  def archive_project_module
 	@project_module.update_attributes(:delete_flag=>true)
    redirect_to list_project_modules_projects_path(:id=>params[:id]), :notice=> 'Project Module was successfully archived.'
  end
  
  def show_project_module
  end
  
  def invite_project_team
  @users = @company.users.includes(:role).where("delete_flag is not true and user_type = 'employee'")
    @project =Project.find(params[:id])
    path = request.env['HTTP_HOST']
    project_contacts = @project.client_contacts.blank? ? [] : @project.client_contacts.where("project_contacts.user_type = \'employee\'").collect!{|i| i.id.to_s}
    received_conacts = params[:team_member_name].split(",") unless params[:team_member_name].blank?
    unless (received_conacts - project_contacts).blank?
      new_contacts = User.where("id IN (#{(received_conacts - project_contacts).join(',')})")
    	new_contacts.each do |x|   
		    @project.project_contacts.create(:user_id=> x.id, :user_type=>'employee', :is_billable=>params[:billable])
			  @project.project_invitation_mail(x, path)
        flash.now[:user] = "User is invited successfully." 
			  
       # proj_info = {:email => x.email, :proj_name => @project.title, :url =>  "http://"+request.env['HTTP_HOST']+"/verify_project_invite?email="+Base64.encode64(x.email)+"&id="+Base64.encode64(@project.id.to_s) } 
			 # UserMailer.project_invite_email(proj_info).deliver
	    end
      else
      flash.now[:user] = "User is already invited." 
    end
    respond_to do |format|
      format.js{}
    end
  end
  
  def verify_project_invite
  	user = User.where("email = '#{Base64.decode64(params[:email])}' AND delete_flag is not true").last
    project = Project.where("id = #{Base64.decode64(params[:id])} AND delete_flag is not true").last
    unless (user.blank? && project.blank?)
      project_contact = ProjectContact.where("user_id = #{user.id} AND project_id = #{project.id}").last 
      project_contact.update_attributes(:is_verified=>true) unless project_contact.blank?
    end
    redirect_to signin_url
  end
  
  def resend_project_invitation
  	path = request.env['HTTP_HOST']
    @project =Project.find(params[:id])
    user = User.find(params[:user_id])
    @project.project_invitation_mail(user, path)
	#flash[:success] = "Project Invite Sent"
    render :json=>true
  end
  
  def delete_project_member
    project_contact = ProjectContact.where("user_id = #{params[:user_id]} and project_id = #{params[:id]}").last 
    project_contact.destroy unless project_contact.blank?
    respond_to do |format|
      format.js{}
    end
  end
  
  def cancel_project_invitation
  end
  
  def cancel_invited_project_invitation
  end
  
  private
  
  def project_params
    params.require(:project).permit(:title, :user_id, :client_id, :company_id, :start_date, :end_date,:project_type,:description,:delete_flag,:committed_hours,:status,:project_files_attributes=> [:files, :project_id, :user_id])
  end
  
  def fc_project_params
    params.require(:project).permit(:total_amount, :advanced_amount, :sign_off_amount, :start_date, :end_date, :no_of_milestones, :starting_date, :fixed_costs_attributes=>[:reason, :milestone_name, :milestone_start_date, :milestone_end_date, :status, :description, :amount, :id, :project_id])
  end
  
  def tm_milestone_params
    params.require(:project).permit(:total_amount, :advanced_amount, :sign_off_amount, :start_date, :end_date, :no_of_milestones, :starting_date, :timematerial_milestones_attributes=>[:reason, :milestone_name, :milestone_start_date, :milestone_end_date, :status, :description, :amount, :id, :project_id])
  end
  
  def tm_project_params
    params.require(:project).permit(:time_materials_attributes=>[:rate_per_hour, :user_id, :rate_start_date, :rate_end_date, :is_active, :id])
  end
  
  def set_project
    @project = Project.includes(:project_files, :client_contacts).find(params[:id])
  end
  
  def employee_type
  	 @project = Project.where("delete_flag is not true AND id = #{params[:id]}").first
     @unverified_employees = @project.client_contacts.where("project_contacts.user_type = \'employee\' and project_contacts.is_verified = \'0\' ")
	 @verified_employees = @project.client_contacts.where("project_contacts.user_type = \'employee\' and project_contacts.is_verified = \'1\'") 
  end
  
  def fc_milestone_params
    params.require(:fixed_cost).permit(:milestone_end_date, :reason)
  end
  
  def tm_milestone_delay_params
    params.require(:timematerial_milestone).permit(:milestone_end_date, :reason)
  end
  
  # def get_all_project
#     @projects = @company.projects.includes([:client, :client_contacts, :project_manager]).where("delete_flag is not true").order("created_at DESC").page(params[:page]).per(15)
#   end
  
  def project_module_params
     params.require(:project).permit(:project_modules_attributes=>[:id, :project_id, :user_id, :name, :description, :delete_flag])
  end
  
  def find_project
  	@project = Project.where("delete_flag is not true AND id = #{params[:id]}").first
  end
  
end
