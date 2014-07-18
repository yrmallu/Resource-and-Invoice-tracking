class CreateFixedCosts < ActiveRecord::Migration
  def change
    create_table :fixed_costs do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :milestone_name
      t.date :milestone_start_date
      t.date :milestone_end_date
      t.string :status
      t.text :description
      t.float :amount
      t.string :currency

      t.timestamps
    end
  end
end
