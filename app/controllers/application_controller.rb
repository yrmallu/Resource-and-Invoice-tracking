class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  include PublicActivity::StoreController
  hide_action :current_user
  before_action :get_project
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user
  
 # before_filter :authentication_check
  
  #USER, PASSWORD = 'cuelogic', 'hrms2013'
  
  def set_company
     unless Rails.cache.exist?("company")
       company = Company.last
       Rails.cache.write 'company', company
     end 
       @company = Rails.cache.read 'company'
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_users_path, :alert => exception.message
  end
  
  def get_role
    @roles = @company.roles.includes(:accessrights).where("delete_flag is not true").order("created_at DESC")
  end
  
  def get_department
    @departments = @company.departments.where("delete_flag is not true").order("created_at DESC")
  end  
  
  def get_project
    set_company
    @projects = @company.projects.includes([:client, :client_contacts, :project_manager]).where("delete_flag is not true").order("created_at DESC")
  end
  
  def get_accessright
    @accessrights = Accessright.all
  end
  
  def get_client
    @clients = @company.clients.where("delete_flag is not true").order("created_at DESC")
  end
  
  def get_user
    @users = @company.users.includes([:department, :role, :addresses, :team_members]).where("delete_flag is not true and user_type='employee'").order("created_at DESC")
  end
  
  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      user == USER && password == PASSWORD
    end
  end

  # def authentication_check
 #    authenticate_or_request_with_http_basic do |user, password|
 #      user == USER && password == PASSWORD
 #    end
 #  end
  
  
  
end

