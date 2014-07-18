class ContactPointsController < ApplicationController

  before_action :logged_in?
  before_action :set_contact_point, :only => [:show, :edit, :update, :destroy]
  before_action :client_id, :only=> [:show, :edit, :update]
  load_and_authorize_resource :only=>[:edit, :destroy, :show]
  
  def show
  end
  
  def edit
    @address = @contact_point.addresses.blank? ? @contact_point.addresses.build : @contact_point.addresses
  end
  
  def update
    if @contact_point.update(contact_point_params)
      @contact_point.create_activity :update, owner: current_user
	  flash[:success] = "Contact Point updated"
      redirect_to contact_point_path(:client_id=>params[:client_id])
    else
      render :action=> 'edit'
    end
  end
  
  def destroy
    #@contact_point.destroy
    @contact_point.update_attributes(:delete_flag=>true)
    @contact_point.create_activity :archived, owner: current_user
	flash[:success] = "Contact Point archived"
    redirect_to contact_detail_clients_path(:id=>@contact_point.client.id)
  end
  
  def email_validation
     @ver = User.where("email = '#{params[:email]}' and id != #{params[:id]}")
     unless (@ver.blank?)
        render :text => "This email is already in use"
      else
        render :text => "avaiable"
     end
   end
  
  private
  
  def client_id
    @client = params[:client_id]
  end
  
  def set_contact_point
    @contact_point = User.includes(:addresses).find(params[:id])
  end
  
  def contact_point_params
    params.require(:user).permit(:firstname,:email,:skype_id,:hangout_id,:client_id, :password, :password_confirmation, :user_type, :photos, :addresses_attributes=>[:id,:mobile])
  end
end
