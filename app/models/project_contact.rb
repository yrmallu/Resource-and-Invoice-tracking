class ProjectContact < ActiveRecord::Base
  belongs_to :project
  belongs_to :client_contact, class_name: "User", :foreign_key => "user_id"
end
