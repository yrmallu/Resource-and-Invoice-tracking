class Technology < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users, :allow_destroy=> true, :reject_if => :all_blank
end
