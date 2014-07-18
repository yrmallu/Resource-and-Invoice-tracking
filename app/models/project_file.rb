class ProjectFile < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_attached_file :files, :styles => { :medium => "300x300>",  :thumb => "100x100>" },
                               :storage => :s3,
                               :s3_credentials => File.join(Rails.root, 'config', 'aws.yml'), #this value depends on the file name that you made at the config file
                               :path => ":class/:attachment/:id/:style.:extension"
end
