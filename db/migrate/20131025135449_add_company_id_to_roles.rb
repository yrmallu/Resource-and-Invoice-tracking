class AddCompanyIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :company_id, :integer
  end
end
