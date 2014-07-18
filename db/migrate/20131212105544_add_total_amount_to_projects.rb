class AddTotalAmountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :total_amount, :float
    add_column :projects, :advanced_amount, :float
    add_column :projects, :sign_off_amount, :float
    add_column :projects, :no_of_milestones, :integer
    add_column :projects, :starting_date, :date
  end
end
