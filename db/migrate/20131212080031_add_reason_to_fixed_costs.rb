class AddReasonToFixedCosts < ActiveRecord::Migration
  def change
    add_column :fixed_costs, :reason, :text
  end
end
