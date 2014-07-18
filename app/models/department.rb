class Department < ActiveRecord::Base
	belongs_to :company
	has_many :users	
	
	validates :name, presence: true, :format => { :with => /\A(([a-zA-Z])+(-?[a-zA-Z]+)*\s?)+\Z/ }, :uniqueness => {:case_sensitive => false}
end
