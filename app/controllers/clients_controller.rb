class ClientsController < ApplicationController

  before_action :logged_in?
  before_action :set_company, :only => [:new,:index,:create,:edit,:get_client,:update, :get_all_client]
  before_action :set_client, :only => [:show, :edit, :update, :destroy, :add_contact_point, :contact_detail]
  before_action :get_all_client, :only=>[:index]
  before_action :get_client_address, :only=>[:edit, :update]
  load_and_authorize_resource :only=>[:new, :index, :show, :edit, :contact_detail, :add_contact_point]
  
  def new
    @client = Client.new
    @address = @client.build_address
  end
  
  def index
    
  end
  
  def show
    
  end
  
  def edit
     
  end
  
  def create
    @client = Client.new(client_params)
    if @client.save
      @client.create_activity :create, owner: current_user
	  flash[:success] = "Client created"
	  redirect_to @client
    else 
      @address = @client.build_address
      render :action=> 'new'
    end
  end
  
  def update
    puts "aaaaa", File.basename(request.referer), File.basename(request.referer).split("?")[0]
    if @client.update(client_params)
      if(File.basename(request.referer).split("?")[0] == "add_contact_point")
	    flash[:success] = "Contact Point created"
        #redirect_to contact_detail_clients_path(:id=>@client.id) and return
		last_contact_point_save_id = User.last.id
		redirect_to contact_point_path(last_contact_point_save_id, :client_id => @client.id) and return
		# :notice=> 'Contact Point was successfully created.' and return
      else
        @client.create_activity :update, owner: current_user
		flash[:success] = "Client updated"
        redirect_to @client
      end
    else
      if(File.basename(request.referer).split("?")[0]== "add_contact_point")
        redirect_to add_contact_point_clients_path(:id=>@client.id) and return 
      else
        render :action=> 'edit' 
      end
    end
  end
  
  def destroy
    @client.update_attributes(:delete_flag=>true)
    @client.create_activity :archived, owner: current_user
	flash[:success] = "Client archived"
    redirect_to clients_url
  end
  
  #Adding contact persons to a particular client
  def add_contact_point
    @contact_point = @client.contact_points.build
    @address = @contact_point.addresses.build
  end
  
  #showing all contact persons related to a client
  def contact_detail
    @contact_points = @client.contact_points.where("delete_flag is not true").order("created_at desc")
  end
  
  private
  
  def set_client
    @client = Client.includes(:address).find(params[:id])
  end
  
  def get_client_address
    @address = @client.address.blank? ? @client.build_address : @client.address
  end
  
  def client_params
    params.require(:client).permit(:name,:website,:description,:delete_flag,:photos,:company_id,:address_attributes=> [:street,:city,:state,:country,:zip_code,:mobile,:telephone_number,:fax_no],:contact_points_attributes=>[:user_type,:password,:password_confirmation,:firstname,:lastname,:email,:skype_id,:hangout_id,:_destroy,:photos, :addresses_attributes=>[:id,:mobile]])
  end
  
  def get_all_client
    @clients = @company.clients.where("delete_flag is not true").order("created_at DESC")
  end
  
end
