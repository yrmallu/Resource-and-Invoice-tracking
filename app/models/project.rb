class Project < ActiveRecord::Base
  #has_and_belongs_to_many :users
  include PublicActivity::Model
  #tracked :owner => proc {|o| o.current_user}
  has_many :project_contacts
  has_many :client_contacts, :through => :project_contacts, class_name: "User"
  belongs_to :client
  belongs_to :company
  belongs_to :project_manager, class_name: "User", foreign_key: :user_id
  has_many :project_files
  has_many :fixed_costs
  has_many :timematerial_milestones
  has_many :time_materials
  has_many :project_modules
  has_many :timesheets
  has_many :tasks
  accepts_nested_attributes_for :project_files, :fixed_costs, :timematerial_milestones, :tasks, :time_materials, :project_modules, :allow_destroy=> true, :reject_if => :all_blank
  validates :title, :presence=>true
  before_update :update_project_manager, :project_manager_update
  
  def contact_persons(contacts)
    unless contacts.blank?
      project_contacts = self.client_contacts.blank? ? [] : self.client_contacts.where("project_contacts.user_type = \'contact_point\'").collect!{|i| i.id.to_s}
      unless (contacts.reject {|x| x.empty?} - project_contacts).blank?
        new_contacts = User.where("id IN (#{(contacts.reject {|x| x.empty?} - project_contacts).join(',')})")
        new_contacts.each{|x| self.project_contacts.create(:user_id=> x.id, :user_type=>'contact_point')} unless new_contacts.blank?
        #new_contacts.each{|x| self.client_contacts << x} unless new_contacts.blank?
      end
      unless (project_contacts - contacts.reject {|x| x.empty?}).blank?
        remove_contacts = User.where("id in (#{(project_contacts - contacts.reject {|x| x.empty?}).join(',')})")
        remove_contacts.each{|x| self.client_contacts.delete(x)} unless remove_contacts.blank?
      end
    end
  end
  
  def update_project_manager
  	if self.user_id_changed?
		ProjectContact.delete_all("user_id = #{self.user_id_was} and project_id = #{self.id}") 
		self.project_contacts.create(:user_id=> self.user_id, :user_type=>"employee", :is_verified=> '1')
  	end
  end
  
  def project_invitation_mail(user, path)
      proj_info = {:email => user.email, :proj_name => self.title, :url =>  "http://"+path+"/verify_project_invite?email="+Base64.encode64(user.email)+"&id="+Base64.encode64(self.id.to_s) } 
	  UserMailer.project_invite_email(proj_info).deliver
  end
  
  def project_created_mail(user, path, action)
   unless action.blank?
	    proj_info = {:email => user.email, :proj_name=>self.title, :url =>  "http://"+path } 
  		UserMailer.project_created(proj_info).deliver
  	else  
	    if @prev_proj_manager_id != @new_proj_manager_id
 			proj_info = {:email => user.email, :proj_name=>self.title, :url =>  "http://"+path } 
   			UserMailer.project_created(proj_info).deliver
 	    end
	end
  end
  
  def project_manager_update
  	@prev_proj_manager_id = self.user_id_was
	@new_proj_manager_id = self.user_id
  end
  
  
end
