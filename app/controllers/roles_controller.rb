class RolesController < ApplicationController

before_action :set_company, :only=>[:new, :index, :create, :get_all_role, :show]
before_action :logged_in?
before_action :get_role, :only=>[:index]
before_action :get_role_by_id, :only=>[:show, :edit, :update, :destroy]
 
  	def new
 		@role = Role.new
  	end

	def create
		@role = Role.new(role_params) 
		respond_to do |format|
	    	format.html {
				if @role.save
					flash[:success] = "Role created"
				    redirect_to roles_path
				else
				    render 'new'
				end
			 }  
			 format.js {
                  @role.save  
				  flash[:success] = "Role created"
             }
		end
	end
	
	def edit
  	end

  	def show
  	end
  
  	def index
  	end
	
   	def update
		respond_to do |format|
	    	format.html {
    			if @role.update(role_params)
					flash[:success] = "Role details updated"
  					redirect_to roles_path
  				else
					redirect_to :action => :edit, :id => @role.id
				end
	 			}  
	 			format.js {
             		@role.update(role_params) 
					flash[:success] = "Role details updated"
        		}
			end
    end
	
  	def destroy
		@role.delete_flag = true
		if @role.save
			flash[:success] = "Role archived"
     		redirect_to roles_path
    	end
  	end
	
    private
    def role_params
       params.require(:role).permit(:name, :company_id)
    end

	def get_role_by_id
	  @role = Role.find(params[:id])
	end
	
    # def get_all_role
#       @role = @company.roles.includes(:accessrights).where("delete_flag is not true").order("created_at DESC").page(params[:page]).per(15)
#     end
  
end
