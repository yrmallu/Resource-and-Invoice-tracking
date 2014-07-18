class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :client_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :project_type
      t.text :description
      t.boolean :delete_flag
      t.string :status

      t.timestamps
    end
  end
end
