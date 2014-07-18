class UsersController < ApplicationController

  before_action :logged_in?, :except => [:forgot_password, :reset_password, :set_new_password, :email_for_password]
  before_action :check_sign_in, :only => [:forgot_password, :reset_password, :set_new_password, :email_for_password]
  before_action :set_company, :only => [:latest_invoice_raise,:new,:create, :edit, :get_user, :index, :update, :show, :user, :list_user_project_detail, :reporting, :dashboard, :get_all_user, :get_project_managers, :resource_track, :total_billable_resource, :allocated_resource, :bench_resource, :get_technologies, :experience_user_info, :billable_resource, :project_dashboard, :fc_allocated_resource, :tm_allocated_resource, :resource_search, :reporting_to ]
  before_action :set_user, :only => [:show, :profile, :edit, :update, :destroy, :get_user_accessright, :update_user_accessright, :list_user_project_detail, :reporting]
  before_action :get_role, :only=>[:new, :edit,:create, :update, :index, :show, :user, :resource_track, :total_billable_resource, :bench_resource, :allocated_resource, :experience_user_info, :fc_allocated_resource, :tm_allocated_resource, :resource_search]
  before_action :get_department, :only=>[:new, :edit, :create, :update, :index, :user]
  before_action :get_accessright, :only=>[:get_user_accessright]
  before_action :get_user, :only=>[:new, :create, :edit, :update, :index, :reporting_to]
  before_action :get_user_projects, :only=>[:latest_invoice_raise, :dashboard]
  before_action :get_project_managers, :only=>[:index, :user]
  before_action :get_technologies, :only=>[:new, :edit, :index, :user, :resource_track, :total_billable_resource, :bench_resource, :allocated_resource, :experience_user_info, :fc_allocated_resource, :tm_allocated_resource, :resource_search]
  before_action :billable_resource, :only=>[:resource_track, :total_billable_resource, :allocated_resource, :bench_resource]
  before_action :employee_type, :only=>[:project_detail, :tm_project_detail]
  
  load_and_authorize_resource :only=>[:show, :new, :edit, :destroy, :get_user_accessright, :index]
  
  def new
    @user = User.new
    @addresses = ["permanent","current"].map{|x| @user.addresses.build(:address_type=>x)}
  end
  
  def show
  end
  
  def profile
  end
  
  def index
  end
  
  def edit
    @user_tech = @user.technologies
    @addresses = @user.addresses.blank? ? ["permanent","current"].map{|x| @user.addresses.build(:address_type=>x)} : @user.addresses
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
	  @user.add_technologies(params[:technology]) unless params[:technology].blank?
      @user.create_activity :create, owner: current_user
	  user_info = {:email => @user.email, :username => @user.firstname+" "+@user.lastname.to_s, :link => "http://"+request.env['HTTP_HOST']+"/reset_password?email="+Base64.encode64(@user.email), :url =>  "http://"+request.env['HTTP_HOST'] } 
	  UserMailer.welcome_email(user_info).deliver
	  flash[:success] = "Employee created"
	  redirect_to users_path
    else 
      render :action=> 'new'
    end
  end
  
  def update
    if @user.update(user_params)
	  @user.add_or_remove_technologies(params[:technology]) unless params[:technology].blank?
      @user.create_activity :update, owner: current_user
	  flash[:success] = "Employee details updated"
      redirect_to users_path
    else
      render :action=>"edit"
    end
  end
  
  def destroy
    @user.update_attributes(:delete_flag=>true)
    @user.create_activity :archived, owner: current_user
	flash[:success] = "Employee archived"
    redirect_to users_url
  end

  def emp_code_validation
     @emp_code_exist= User.where("emp_code = '#{params[:emp_code]}' and id != #{params[:id]}")
     unless (@emp_code_exist.blank?)
        render :text => "This employee code is already in use"
      else
        render :text => "avaiable"
     end
   end
   
  def reporting_to
  	unless params[:user_id].blank?
  		@reporting_to = @company.users.where("id = #{params[:user_id]} AND delete_flag is not true and user_type='employee'").order("created_at DESC").last
	end
	render :partial=>"reporting_to"
  end

  def user
  	respond_to do |format|
		
		format.js{
			
			arrayConditions = Array.new
			# check if user has entered name in textfield
			arrayConditions << '(firstname like ' + "'%" + params[:user_fname] + "%')" unless(params[:user_fname].blank?)
			
			arrayConditions << '(lastname like ' + "'%" + params[:user_lname] + "%')" unless(params[:user_lname].blank?)
			
			# check if user has entered education in textfield
			arrayConditions << 'education like ' + "'%" + params[:education_name] + "%'" unless(params[:education_name].blank?)
			
			# check if user has selected department in dropdown
			arrayConditions << 'department_id =' + params[:department_id] unless(params[:department_id].blank?)
			
			# check if user has selected role in dropdown
			arrayConditions << 'role_id =' + params[:role_id] unless(params[:role_id].blank?)
			
			# check if user has selected gender in dropdown
			genderValue = params[:gender_type].downcase
			arrayConditions << 'gender =' + "'" + genderValue + "'" unless(params[:gender_type].blank?)
			
			# check if user has selected employee type in dropdown
			employeeTypeValue = params[:user_type].downcase
			if "billable".eql?(employeeTypeValue)
				employeeTypeValue = "billable"
			else
				employeeTypeValue = "non_billable"
			end
			arrayConditions << 'resource_type =' + "'" + employeeTypeValue + "'" unless(params[:user_type].blank?)
			
			# check if user has selected joining date in datepicker
			arrayConditions << "(joining_date between '" + params[:from_joining_date_value] + "' AND '" + params[:to_joining_date_value] + "')" unless(params[:from_joining_date_value].blank? && params[:to_joining_date_value].blank?)
			
			# check if user has selected age in slider
			
			strAge = params[:slider_value].to_s
			arrAge = strAge.split(",")
				
			# subtract input years from current year to get year which range is checked in DB
			# append '-0-0' at end of year like '1990-0-0'
				
			arrayConditions << "( date_of_birth between '" + (Time.now.year.to_i - arrAge[1].to_i).to_s + '-1-1' + "' AND '" + (Time.now.year.to_i - arrAge[0].to_i).to_s + '-1-1' + "')" unless(params[:slider_value].blank?)
			
			arrayConditions << "addresses.city = '" + params[:city_name] + "'" unless params[:city_name].blank?
			arrayConditions << "addresses.state = '" + params[:state_name] + "'" unless params[:state_name].blank?
			arrayConditions << 'technologies.id IN ' + '(' + params[:technology].join(",") + ')' unless params[:technology].blank?
			arrayConditions << "delete_flag is not true"
			p arrayConditions
			# join all the conditions with AND condition
			# also search all employees to a specific company
			p strConditions = arrayConditions.join(' AND ') unless arrayConditions.empty?
			@users = @company.users.includes(:addresses, :technologies).where(strConditions).references(:addresses)
			
			#p @users = @users.joins(:addresses).where( "addresses.city" => params[:city_name])
			#p @users = @users.joins(:addresses).where( "addresses.state" => params[:state_name])

			}
  	end
  end 

  def get_user_accessright
    @access_rights = @user.user_permission_names.collect{|i| i.id.to_s}
    #@access_rights =  ((@user.role_access_rights) + @user.added_user_access_rights) - @user.removed__user_access_rights
  end
  
  def update_user_accessright
    role_access_rights = @user.role_access_rights.collect!{|i| i.id.to_s}
    removed__user_access_rights = @user.removed__user_access_rights.collect!{|i| i.id.to_s}
    added_user_access_rights = @user.added_user_access_rights.collect!{|i| i.id.to_s}
    existing_access_rights = role_access_rights + removed__user_access_rights + added_user_access_rights
    have_to_remove = params[:unchecked_list].reject {|x| x.empty?}.join(",").split(",") & existing_access_rights.uniq
    have_to_add = params[:checked_list].reject {|x| x.empty?}.join(",").split(",") - ((role_access_rights + added_user_access_rights) - removed__user_access_rights).uniq
    @user.access_to_remove_or_add(:accessright=>have_to_remove,:boolean=>true,:removed=>removed__user_access_rights,:added=>added_user_access_rights)
    # have_to_remove.each do |access|
    #   unless (removed__user_access_rights + added_user_access_rights).include?(access)
    #     @user.user_accessrights.create(:accessright_id=>access, :access_flag=>true)
    #   else
    #     @user.user_accessrights.where("accessright_id=#{access}").first.update({:access_flag=>true})
    #   end        
    # end 
    @user.access_to_remove_or_add(:accessright=>have_to_add,:boolean=>false,:removed=>removed__user_access_rights,:added=>added_user_access_rights)

    redirect_to get_user_accessright_users_path(:id=>@user.id)
  end
  
  def user_params
    params.require(:user).permit(:firstname, :resource_type, :lastname, :email, :password, :password_confirmation,:delete_flag,:photos,:company_id,:user_type,:emp_code,:gender,:role_id,:boss_id,:department_id,:joining_date,:experience,:education,:date_of_birth,:technology=>[],:addresses_attributes=> [:id,:address_type,:street,:city,:state,:country,:zip_code,:mobile,:telephone_number,:fax_no], :technologies_attributes=>[:id,:name=>[]])
  end
  
  def set_user
    @user = User.includes([:department, :role, :addresses, :boss]).find(params[:id])
  end
  
  def get_technologies
    @technologies = @company.technologies
  end
   
   def reset_password
   		@email_id = Base64.decode64(params[:email])
   		render :layout=>"login"
		
   end
   
   def set_new_password
   	 if params[:password] != ""
  		p @user = User.find_by_email(params[:email_id].downcase)
  		@user.password = params[:password]
  		@user.password_confirmation = params[:password]
  		if @user.save
		  flash[:success] = "Signin with new password"
  		  redirect_to signin_path
  		end
  	 else
	    flash[:error] = "Please enter new password"
  		redirect_to reset_password_path
  	 end
   end
   
   def forgot_password
   		render :layout=>"login"
   end
  
   def email_for_password
     @user = User.find_by_email(params[:email].downcase)
  	 if @user.blank?
	    flash[:error] = "Email does not exist"
  		redirect_to forgot_password_path
  	 else
  		user_info = {:email => @user.email, :username => @user.firstname+" "+@user.lastname.to_s, :link => "http://"+request.env['HTTP_HOST']+"/reset_password?email="+Base64.encode64(@user.email), :url =>  "http://"+request.env['HTTP_HOST'] } 
  		UserMailer.forgot_password_email(user_info).deliver
		flash[:success] = "Email sent with password reset instructions"
  		redirect_to signin_path
  	 end
   end
   
   def list_user_project_detail
	  @user = User.includes([:team_members, :projects=>[{:client_contacts=>[:role]}]]).where("id = #{params[:id]} AND delete_flag is not true").last
   end
   
   # def reporting
   #  	  @users = User.includes(:team_members).where("id = #{params[:id]} AND delete_flag is not true").last
   # end
   
   def latest_invoice_raise

   end
   
   def dashboard

   end
   
   def get_user_projects
     if current_user.is_admin?
     	@projects = @company.projects.includes(:project_manager, :fixed_costs).where("delete_flag is not true")
     else
     	@projects = current_user.projects.includes(:project_manager, :fixed_costs).where("delete_flag is not true")
     end
   end
  
  def get_all_started_projects   
    @projects = @company.projects.includes(:client_contacts, :fixed_costs, {:timesheets=>[{:user=>[:timesheets]}]}).where("status in ('started') and delete_flag is not true").order("created_at DESC") 
  end
   
  def project_dashboard
  	#puts "aaaaa", (60/75)*100
  	get_all_started_projects
  	holidays = @company.public_holidays.map(&:holiday_date)
  	@total_hours_spent = 0
  	@off_track_projects = 0
  	@employees = []
  	@proj_res = {}
  	@delayed_milestones = 0
  	@missed_timesheets = 0
  	@hashMilestone = {} 
  	
  	unless @projects.blank?
    	@projects.each do |project|
			hrs_spent_billable = 0
			
			# Dispalying current milestone for fixed cost project
			if project.project_type.eql?("fixed_cost")
				current_milestone = FixedCost.where("project_id = #{project.id} AND (milestone_start_date <= '#{Time.now.strftime("%Y/%m/%d")}' AND milestone_end_date >= '#{Time.now.strftime("%Y/%m/%d")}')").last
	   			unless current_milestone.blank?
					@hashMilestone.merge! ({"#{project.id}" => current_milestone.milestone_name })
				else
					@hashMilestone.merge! ({"#{project.id}" => "0" })
				end
    		end
		
			# Calculating missed milestone for FC and TM projects
			# missed milestone = if dealyed reason is present and milestone date has passed current date and invoice yet not raised
			if "fixed_cost".eql?(project.project_type)
				project.fixed_costs.each do |mile|
        			@delayed_milestones += 1 if !mile.reason.blank? || (mile.milestone_end_date.to_date < Time.now && "payment_received".eql?(mile.status) )
      			end
			else
				project.timematerial_milestones.each do |mile|
        			@delayed_milestones += 1 unless mile.reason.blank?
      			end
			end
		
      		working_days = []
      		((project.start_date.blank? ? Time.now.to_date : project.start_date)...Time.now.to_date).count {|day|  working_days << day.to_s if !day.saturday? && !day.sunday? && !holidays.include?(day)}
      		unless project.client_contacts.blank?
        		unless project.tasks.blank?
					project.tasks.each do |x|
            			next if !("billable".eql?(x.user.resource_type))
            			hrs_spent_billable += x.hours
          			end
            	end
			
			hrs_spent_for_project = 0
        	#hrs_spent_for_project = project.timesheets.map(&:total_hours).compact.inject(:+) unless project.timesheets.map(&:total_hours).compact.blank? unless project.client_contacts.blank?
        	#@total_hours_spent += hrs_spent_for_project
        	
			hrs_spent_for_project = project.tasks.map(&:hours).compact.inject(:+) unless project.tasks.map(&:hours).compact.blank? unless project.client_contacts.blank?
        	@total_hours_spent += hrs_spent_for_project
        	
			#puts "ssssssssss", hrs_spent_for_project, project.committed_hours.to_i, hrs_spent_billable
			@off_track_projects += 1 if (hrs_spent_billable > project.committed_hours.to_i) if "fixed_cost".eql?(project.project_type)
			
			# Display resources only which are verified
			@proj_res.store(project.id,0)
        	project.project_contacts.each do |verified_users|
				next if ("contact_point".eql?(verified_users.user_type) || verified_users.is_verified.eql?(false))
				unless verified_users.client_contact.delete_flag.eql?(true)
        @proj_res[project.id] += 1
				@employees << verified_users.client_contact
      end
			end
			
			project.client_contacts.each do |user|
          		next if ("contact_point".eql?(user.user_type))
          	  		#p "daysssss", user.firstname, working_days
					user.timesheets.collect{|x| x.timesheet_date.to_s}
          		  	@missed_timesheets +=  (working_days - user.timesheets.collect{|x| x.timesheet_date.to_s}).count
          		  	#@proj_res[project.id] += 1
					#@employees << user.id
          		  	next if !("billable".eql?(user.resource_type))
			   end
      	    end
        end
    end
  end
  
  def proj_dashboard_details
  	@holidays = @company.public_holidays.map(&:holiday_date)
  	@project_tasks = @project.tasks.where("task_type_id= \'1\'")
  	@received_amount = @project.advanced_amount.blank? ? 0 : @project.advanced_amount
  	@completed_hour = @project_tasks.blank? ? 0 : @project_tasks.map(&:hours).inject { |sum, n| sum + n }
  end
   
  def employee_type
  	 @project = Project.where("delete_flag is not true AND id = #{params[:id]}").first
     @unverified_employees = @project.client_contacts.where("project_contacts.user_type = \'employee\' and project_contacts.is_verified = \'0\' ")
	 @verified_employees = @project.client_contacts.where("project_contacts.user_type = \'employee\' and project_contacts.is_verified = \'1\'") 
  end 
    
  def project_detail
  	@project = Project.includes(:fixed_costs).where("id = #{params[:id]}").last
  	get_all_started_projects
  	proj_dashboard_details  	
	
	unless @project.fixed_costs.blank?
    	@end_date = (@project.fixed_costs.size <=1) ? @project.fixed_costs.first.milestone_end_date : @project.fixed_costs.last.milestone_end_date
    	
		# get total days from first milestone start date to last milestone end date
		total_days = (@project.fixed_costs.first.milestone_start_date..@end_date).count {|day| !day.saturday? && !day.sunday? && !@holidays.include?(day)}
    	
		# get worked/completed days from first milestone start date to current date
		worked_days = (@project.fixed_costs.first.milestone_start_date...Time.now.to_date).count {|day| !day.saturday? && !day.sunday? && !@holidays.include?(day)}
    	
		unless total_days.blank?
			@project_status = ((worked_days.to_f/total_days.to_f)*100).round
			if @project_status > 100
				@off_track_days = (@project.end_date...Time.now.to_date).count {|day| !day.saturday? && !day.sunday? && !@holidays.include?(day)}
				@project_status = 100
			elsif @project_status <= 0
				@project_status = 0
			end
		else
			@project_status = 0
		end
		@project.fixed_costs.each{|x| @received_amount += x.amount if "payment_received".eql?(x.status)}
    end
  end

  def tm_project_detail
  	@project = Project.includes(:timematerial_milestones).where("id = #{params[:id]}").last
  	get_all_started_projects
	proj_dashboard_details
	
	# get total months from project start date to project end date
	total_months = (@project.end_date.year * 12 + @project.end_date.month) - (@project.start_date.year * 12 + @project.start_date.month)
	
	# get completed month from project start date to current month
	worked_month = (Time.now.year * 12 + Time.now.month) - (@project.start_date.year * 12 + @project.start_date.month)
	
	unless total_months.blank?
		@project_status = ((worked_month.to_f/total_months.to_f)*100).round
		if @project_status > 100
			@project_status = 100
		elsif @project_status <= 0
			@project_status = 0
		end
	else
		@project_status = 0
	end
	# @total_days = (@project.start_date..@project.end_date).count {|day| !day.saturday? && !day.sunday? && !holidays.include?(day)}
	# worked_days = (@project.start_date...Time.now.to_date).count {|day| !day.saturday? && !day.sunday? && !holidays.include?(day)}
	# @project_status = ((worked_days.to_f/@total_days.to_f)*100).round
	# @total_amount = ((@project.end_date.year * 12 + @project.end_date.month) - (@project.start_date.year * 12 + @project.start_date.month)) * @project.time_materials.map(&:rate_per_hour).inject { |sum, n| sum + n }
  end
   
  def get_project_managers
  	@arrayProjectManagers =[]
	@all_users = @company.users.where("delete_flag is not true and user_type='employee'").order("created_at DESC")
	arrayUserIds = @all_users.map(&:id) 
	@projects = @company.projects.where("user_id IN ('#{arrayUserIds.join("','")}')  AND delete_flag is not true ")
	@projects.each do |project|
		@arrayProjectManagers<<project.project_manager.id
	end
		@arrayProjectManagers.uniq
  end
    
  def resource_track
     first_quarter = Date.new(Date.today.year,1,1) + 3.months
     second_quarter = first_quarter + 3.months
     third_quarter = second_quarter + 3.months
     fourth_quarter = third_quarter + 3.months
     puts first_quarter, second_quarter, third_quarter, fourth_quarter
     months = {1=>first_quarter, 2=>first_quarter, 3=>first_quarter, 4=>second_quarter, 5=>second_quarter, 6=>second_quarter, 7=>third_quarter, 8=>third_quarter, 9=>third_quarter, 10=>fourth_quarter, 11=>fourth_quarter, 12=>fourth_quarter}
     @res_availability = params[:res_range].blank? ? Time.now.to_date : "month".eql?(params[:res_range]) ? Time.now.end_of_month.to_date : months[Time.now.month].to_date
  	 # @billable_res = @company.users.where("delete_flag is not true and user_type='employee' and resource_type='billable'")
     @user_current_project = {}
	 @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and delete_flag is not true and end_date > '#{@res_availability}'")
	 @employees = []
     @fc = []
     @tm = []
     @technology = {"Others"=>[]}
     @technologies.each{|tech| @technology[tech.name] = [] }
     #@technology = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
     @projects.each do |project|
     	unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
            @employees << user unless @employees.include?(user)
            puts "@employees",@employees.count
            @fc << user.id  unless @fc.include?(user.id) if "fixed_cost".eql?(project.project_type)
            p "fixed cost", @fc
            @tm << user.id unless @tm.include?(user.id) if "t_and_m".eql?(project.project_type)
          end
        end
     end
      p "toral", @billable_res.map(&:id)
      p "allocated", @employees.map(&:id)
     
      p "benchhhh",@billable_res.count, @employees.count, @bench_res = @billable_res - @employees
       p "bench", @bench_res.map(&:id)
       unless @bench_res.blank?
         @bench_res.each do |user|
              user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
            # user.technologies.each{|tech| @technology[tech.name] << user} unless user.technologies.blank?
           # unless user.technology.blank?
#              user.technology.split(",").reject {|x| x.empty?}.each do |tech|
#                @technology[tech] << user
#              end  
#            end
         end
       end
    end
    
    def total_billable_resource
     # @billable_res = @company.users.where("delete_flag is not true and user_type='employee' and resource_type='billable'")
      #@technology = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started')")
      @technology = {"Others"=>[]}
      @user_current_project = {}
      @technologies.each{|tech| @technology[tech.name] = [] }
      unless @billable_res.blank?
        @billable_res.each do |user|
          user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
          end
        end
      end
    end
    
    
    def allocated_resource
     # @billable_res = @company.users.where("delete_flag is not true and user_type='employee' and resource_type='billable'")
      @technology = {"Others"=>[]}
      @technology_fc = {}
      @technology_tm = {}
      @user_current_project = {}
      #@technology_fc = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
      #@technology_tm = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
      @technologies.each{|tech| @technology[tech.name] = [] }
      @technologies.each{|tech| @technology_fc[tech.name] = [] }
      @technologies.each{|tech| @technology_tm[tech.name] = [] }
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{params[:res_range]}'")
      @employees = []
      @fc = []
      @tm = []
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
            @employees << user unless @employees.include?(user)
            puts "@employees",@employees.count
            @fc << user if "fixed_cost".eql?(project.project_type)
            @tm << user if "t_and_m".eql?(project.project_type)
          end
        end
      end
      unless @fc.blank?
        @fc.each do |user|
          user.technologies.each{|tech| @technology_fc[tech.name] << user} unless user.technologies.blank?
        end
      end
      unless @employees.blank?
        @employees.each do |user|
          user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end
      unless @tm.blank?
        @tm.each do |user|
          user.technologies.each{|tech| @technology_tm[tech.name] << user} unless user.technologies.blank?
        end
      end
      p "ssssss", @technology
    end
    
    def fc_allocated_resource
      @technology = {"Others"=>[]}
      @user_current_project = {}
      @fc = []
      @technologies.each{|tech| @technology[tech.name] = [] }
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{params[:res_range]}'")
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
            @fc << user unless @fc.include?(user) if "fixed_cost".eql?(project.project_type)
          end
        end
      end
      unless @fc.blank?
        @fc.each do |user|
          user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end
    end
    
    def tm_allocated_resource
      @technology = {"Others"=>[]}
      @user_current_project = {}
      @tm = []
      @technologies.each{|tech| @technology[tech.name] = [] }
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{params[:res_range]}'")
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
            @tm << user unless @tm.include?(user) if "t_and_m".eql?(project.project_type)
          end
        end
      end
      unless @tm.blank?
        @tm.each do |user|
          user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end
    end
    
    def bench_resource
     # @billable_res = @company.users.where("delete_flag is not true and user_type='employee' and resource_type='billable'")
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{params[:res_range]}'")
      @employees = []
      @technology = {"Others"=>[]}
      @user_current_project = {}
      @technologies.each{|tech| @technology[tech.name] = [] }
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @user_current_project.store(user.id,project.title)
            @employees << user unless @employees.include?(user)
          end
        end
      end
      @bench_res = @billable_res - @employees
      unless @bench_res.blank?
        @bench_res.each do |user|
            user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end  
    end
    
    def billable_resource
      @billable_res = @company.users.where("delete_flag is not true and user_type='employee' and resource_type='billable'")
    end
    
    def upload_emp_doc
      @user = User.find(params[:id])
      @user_file = @user.project_file.blank? ? @user.build_project_file : @user.project_file 
    end
    
    def save_emp_doc
      @user = User.find(params[:id])
      if @user.update(user_file_params)
        render :text=> "true"
      else
        render :action=>"upload_emp_doc"
      end
      # if params[:id].blank?
#         @user_file = ProjectFile.new(user_file_params)
#         @user_file.save
#       else
#         @user_file = ProjectFile.find(params[:id])
#         @user_file.update(user_file_params)
#       end
    end
    
    def user_file_params
      params.require(:user).permit(:project_file_attributes=>[:id,:user_id, :files])
    end
   
    def experience_user_info
      res_availability = params[:res_range].blank? ? Time.now.to_date : params[:res_range]
      query = "delete_flag is not true and user_type='employee' and resource_type='billable'"
      
      
      query += " and technologies.name in ('#{params[:tech]}')" unless params[:tech].eql?("all")
      query += "and experience = #{params[:experience].to_f}" unless params[:experience].eql?("All")
      @tech = params[:tech]
      @allocation_type = params[:allocation_type]
       p "aaa", @billable_res = @company.users.includes(:technologies).where(query).references(:technologies)
       if params[:res_type].eql?("bench")
         @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{params[:res_range]}'")
         @employees = []
         @technology = {}
         @technologies.each{|tech| @technology[tech.name] = [] }
         @projects.each do |project|
           unless project.client_contacts.blank?
             project.client_contacts.each do |user|
               next if ("contact_point".eql?(user.user_type))
               next if !("billable".eql?(user.resource_type))
               @employees << user
             end
           end
         end
        p "bench", @employees, @resources = @billable_res - @employees
       elsif params[:res_type].eql?("total")
         @technology = {}
         @technologies.each{|tech| @technology[tech.name] = [] }
         unless @billable_res.blank?
           @billable_res.each do |user|
             user.technologies.each{|tech| @technology[tech.name] << user} unless user.technologies.blank?
           end
         end
         @resources = @billable_res
       else
         @technology_fc = {}
         @technology_tm = {}
         #@technology_fc = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
         #@technology_tm = {'ror'=>[], 'php'=>[], 'android'=>[], 'iphone'=>[]}
         @technologies.each{|tech| @technology_fc[tech.name] = [] }
         @technologies.each{|tech| @technology_tm[tech.name] = [] }
         @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started') and end_date > '#{res_availability}'")
         @employees = []
         @fc = []
         @tm = []
         @projects.each do |project|
           unless project.client_contacts.blank?
             project.client_contacts.each do |user|
               next if ("contact_point".eql?(user.user_type))
               next if !("billable".eql?(user.resource_type))
               @employees << user
               puts "@employees",@employees.count
              p "aaaaaa", @fc << user if "fixed_cost".eql?(project.project_type)
               @tm << user if "t_and_m".eql?(project.project_type)
             end
           end
         end
         unless @fc.blank?
           @fc.each do |user|
             user.technologies.each{|tech| @technology_fc[tech.name] << user} unless user.technologies.blank?
           end
         end
         unless @tm.blank?
           @tm.each do |user|
             user.technologies.each{|tech| @technology_tm[tech.name] << user} unless user.technologies.blank?
           end
         end
         @resources = @billable_res & @employees
       end
       
   #  render :partial=>"resource_info" and return unless @resources.blank?
    # render :partial=>"resource_info"
    end
    
    def resource_search
      @res_tb_type = params[:res_tb_type]
      query = "delete_flag is not true and user_type='employee'"
      query += " and technologies.id in (#{params[:tech].join(",")})" unless params[:tech].blank?
      query += "and experience  #{params[:exp_cond]} #{params[:exp].to_f}" unless params[:exp].blank?
      query += " and gender = '#{params[:gender]}' " unless params[:gender].blank?
      query += " and role_id in (#{params[:role].join(",")}) " unless params[:role].blank?
      query += " and resource_type in (" + "'" + "#{params[:res_type].join("','")}" + "'" + ") " unless params[:res_type].blank?
      @res = @company.users.includes(:technologies).where(query).references(:technologies)
      @technology = {"Others"=>[]}
      @employees = []
      @user_current_project = {}
      @technologies.each{|tech| @technology[tech.name] = [] }
      @projects = @company.projects.includes(:client_contacts).where("status in ('not_started','started')")
      @projects.each do |project|
        unless project.client_contacts.blank?
          project.client_contacts.each do |user|
            next if ("contact_point".eql?(user.user_type))
            next if !("billable".eql?(user.resource_type))
            @employees << user unless @employees.include?(user)
            @user_current_project.store(user.id,project.title)
          end
        end
      end
      @res = @res - @employees  unless params[:res_status].blank?
      unless @res.blank?
        @res.each do |user|
          user.technologies.blank? ?  @technology["Others"] << user  : user.technologies.each{|tech| @technology[tech.name] << user}
        end
      end  
    end
end
