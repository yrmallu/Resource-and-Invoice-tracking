class TimeMaterial < ActiveRecord::Base
  include PublicActivity::Model
  tracked :owner => proc {|o| o.current_user}	
  belongs_to :project
end
