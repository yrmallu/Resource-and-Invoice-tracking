class Company < ActiveRecord::Base
  has_many :departments
  has_many :clients
  has_many :users
  has_many :roles
  has_many :projects
  has_many :public_holidays
  has_many :technologies
  accepts_nested_attributes_for :departments,:clients, :users, :roles, :projects, :technologies, :allow_destroy=> true, :reject_if => :all_blank

	validates :name, presence: true, length: { maximum: 50}
	

end
