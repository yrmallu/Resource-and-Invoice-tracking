class CompaniesController < ApplicationController
  
	def new
  		@company = Company.new
  	end

  	def edit
  	end

  	def show
  		@company = Company.find(params[:id])
  	end
  
  	def update
   		@company = Company.find(params[:id])	
	end

	private
   	def company_params
    	params.require(:company).permit(:id, :name, :website, :domain, :telephone_number, :mobile, departments_attributes: [:name], roles_attributes: [:name]) 
   	 end
	 
end
