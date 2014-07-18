class User < ActiveRecord::Base
  include PublicActivity::Model
  #tracked :owner => proc {|o| o.current_user}, :if=>:check_user_type?
  tracked :on => {:create => proc {|model, controller| ["employee","contact_point"].include?(model.user_type) }}, :owner => proc {|o| o.current_user}, :only=>:create
  belongs_to :client
  belongs_to :company
  has_many :addresses
  belongs_to :role
  belongs_to :department
  has_many :user_accessrights
  has_many :employee_projects, :class_name=>"Project"
  has_many :accessrights, :through => :user_accessrights
  has_many :team_members, class_name: "User", foreign_key: :boss_id
  belongs_to :boss, class_name: "User", foreign_key: :boss_id
  #has_and_belongs_to_many :projects
  has_many :project_contacts
  has_many :timesheets
  has_many :tasks
  has_many :projects, :through => :project_contacts
  has_one :project_file
  #has_many :project_employees
  #has_many :projects, :through => :project_employees
  has_and_belongs_to_many :technologies
  accepts_nested_attributes_for :addresses, :project_file, :technologies, :timesheets, :allow_destroy=> true, :reject_if => :all_blank
  
  has_secure_password
  
  before_save { self.email = email.downcase }
  has_attached_file :photos, :styles => { :medium => "300x300>",  :thumb => "100x100>" },
                               :storage => :s3,
                               :s3_credentials => File.join(Rails.root, 'config', 'aws.yml'), #this value depends on the file name that you made at the config file
                               :path => ":class/:attachment/:id/:style.:extension"
  
  validates :firstname, :presence=>true
  validates :date_of_birth, :presence=>true, :if=>:check_user_type?
  #validates :emp_code, :presence=>true, :format => { :with => /\A(([a-zA-Z])+(-?[a-zA-Z]+)*\s?)+\Z/ }, :uniqueness => {:case_sensitive => false}, :if=>:check_user_type?
  #validates :company_id, :presence=>true
  
 # validates :password, :presence=>true, length: {minimum: 5, maximum: 40}, :on => :create
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence=> true, :format=>{:with=>VALID_EMAIL_REGEX},:uniqueness=>{:case_sensitive=>false}
  before_save :calculate_age, :if=>:check_user_type?
  before_save :check_user_role_id
 # before_save :set_technology, :if=>:check_user_type?
  # validate do |user|
 #    user.errors.add :base, "Age should be greater than 18" if check_user_type?
 #  end
   def set_technology
     self.technology = self.technology.join(",") if self.technology.is_a?(Array) unless self.technology.blank?
   end
 
  def get_full_detail
    get_full_name + " " + "(" + get_user_role.to_s + ")"
  end
  
  def check_user_type?
    if (user_type == "employee")
        return true 
    else
        return false
    end
  end
  
  def get_full_name
  	unless self.lastname.blank?
	    self.firstname + " " + self.lastname 
	else
		self.firstname
	end
  end
  
  def get_user_role
    self.role.name unless self.role.blank?
  end
  
  def calculate_age
    errors.add :base, "Age should be greater than 18"
    end_date = Date.today
    start_date = date_of_birth
    age = end_date.year - start_date.year - ((end_date.month > start_date.month || (end_date.month == start_date.month && end_date.day >= start_date.day)) ? 0 : 1)
    if age > 18
	  return true
    else
	  return false
    end
  end
  
  def access_to_remove_or_add(options={})
    options[:accessright].each do |access|
      unless (options[:removed] + options[:added]).include?(access)
        self.user_accessrights.create(:accessright_id=>access, :access_flag=>options[:boolean], :role_id=>self.role.id)
      else
        self.user_accessrights.where("accessright_id=#{access}").first.update({:access_flag=>options[:boolean], :role_id=>self.role.id})
      end        
    end 
  end
  
  def added_user_access_rights
    self.accessrights.where("access_flag = false")
  end
  
  def removed__user_access_rights
    self.accessrights.where("access_flag = true")
  end
  
  def role_access_rights
    self.role.blank? ? [] : self.role.accessrights.blank? ? [] : self.role.accessrights
  end
  
  def user_permissions
    return (role_access_rights + added_user_access_rights) - removed__user_access_rights
  end
  
  def user_permission_names
    user_permissions.blank? ? role_access_rights : user_permissions
    # puts 'user_accessrights_'+self.id.to_s
    # if Rails.cache.read('user_accessrights_'+self.id.to_s).blank?
    #   Rails.cache.write 'user_accessrights_'+self.id.to_s,  ((role_access_rights + added_user_access_rights) - removed__user_access_rights)
    # end
    # return Rails.cache.read('user_accessrights_'+self.id.to_s)
  end
  
  def check_user_role_id
    Rails.cache.delete('user_accessrights_'+self.id.to_s) if self.role_id_changed?
  end
  
  def self.super_admin
    (Rails.cache.read 'company').users.where("is_admin = true").first
  end
  
  def add_technologies(technologies)
      tech = check_technology(technologies)
      tech.each{|x| self.technologies << x} unless tech.blank?
  end
  
  def add_or_remove_technologies(technologies)
  	tech = check_technology(technologies).map(&:id)
    exist_tech = self.technologies.map(&:id)
    new_tech = tech - exist_tech
	final_tech = check_technology(new_tech) unless new_tech.blank?
    final_tech.each{|x| self.technologies << x} unless final_tech.blank?
    remove_tech = exist_tech - tech
	result_technologies = check_technology(remove_tech) unless remove_tech.blank?
    result_technologies.each{|x| self.technologies.delete(x)} unless result_technologies.blank?
  end
  
  def check_technology(technologies)
	Technology.where("id in (#{technologies.join(",")})")
  end
                         
  # before_create :create_remember_token
#   def User.new_remember_token
#       SecureRandom.urlsafe_base64
#   end
# 
#   def User.encrypt(token)
#       Digest::SHA1.hexdigest(token.to_s)
#   end
# 
#   private
# 
#   def create_remember_token
#         self.remember_token = User.encrypt(User.new_remember_token)
#   end
end
