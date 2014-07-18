class ContentsController < ApplicationController

 before_action :check_sign_in, only: [:home]
 layout "front_end"
  
  def home
  	#render :layout=>"front_end"
  end

end
