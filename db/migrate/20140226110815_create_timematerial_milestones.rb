class CreateTimematerialMilestones < ActiveRecord::Migration
  def change
    create_table :timematerial_milestones do |t|
      t.integer :project_id
      t.string :milestone_name
      t.date :milestone_start_date
      t.date :milestone_end_date
      t.string :status
      t.text :description
      t.float :amount
      t.string :currency
      t.text :reason

      t.timestamps
    end
  end
end
