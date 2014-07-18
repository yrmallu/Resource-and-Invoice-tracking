class DepartmentsController < ApplicationController

	before_action :set_company, :only=>[:new, :index, :create, :get_all_department, :show]
	before_action :logged_in?
	before_action :get_department, :only=>[:index]
	before_action :get_department_by_id, :only=>[:show, :edit, :update, :destroy]
	load_and_authorize_resource :only=>[:new, :index, :show, :edit]

    def new
        Rails.cache.read('user_accessrights')
    	@department = Department.new
    end
		
	def create
		@department = Department.new(department_params) 
		respond_to do |format|
	    	format.html {
				if @department.save
					flash[:success] = "Department created"
				    redirect_to departments_path
				else
					#flash[:error] = "Department not created"
				    render 'new'
				end
			 }  
			 format.js {
                  @department.save  
				  flash[:success] = "Department created"
             }
		end	 
	end
	
	def index	
  	end
	
    def show
    end
	
    def edit
    end

   	def update
		respond_to do |format|
	    	format.html {
    			if @department.update(department_params)
					flash[:success] = "Department details updated"
  					redirect_to departments_path
  				else
					#flash[:error] = "Department details not updated"
					redirect_to :action => :edit, :id => @department.id
				end
	 			}  
	 			format.js {
             		@department.update(department_params) 
					flash[:success] = "Department details updated"
        		}
			end
    end
	
    def destroy
		@department.delete_flag = true
		if @department.save
			flash[:success] = "Department archived"
     		redirect_to departments_path
    	end
	end
	
    private
    def department_params
		params.require(:department).permit(:name, :company_id)
    end
	
	def get_department_by_id
		@department = Department.find(params[:id])
	end
	
	# def get_all_department
# 		@department = @company.departments.where("delete_flag is not true").order("created_at DESC").page(params[:page]).per(15)
# 	end
end
