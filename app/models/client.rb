require 'url_validator'
class Client < ActiveRecord::Base
  include PublicActivity::Model
  #tracked :owner => proc {|o| o.current_user}
  belongs_to :company
  has_one :address
  has_many :projects
  has_many :contact_points, :class_name => "User"
  accepts_nested_attributes_for :address,:contact_points,:projects, :allow_destroy=> true, :reject_if => :all_blank
  validates :name, :presence=>true
  #validates :website, :presence => true, url: true, :if=>:check_wibsite_val?
  has_attached_file :photos, :styles => { :medium => "300x300>",  :thumb => "100x100>" },
                               :storage => :s3,
                               :s3_credentials => File.join(Rails.root, 'config', 'aws.yml'), #this value depends on the file name that you made at the config file
                               :path => ":class/:attachment/:id/:style.:extension"
                               
  
  def check_wibsite_val?
      if website.blank?
        return false
      else
        return true
      end
  end                             
          
end
