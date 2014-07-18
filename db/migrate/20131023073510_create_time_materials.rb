class CreateTimeMaterials < ActiveRecord::Migration
  def change
    create_table :time_materials do |t|
      t.integer :project_id
      t.integer :user_id
      t.float :rate_per_hour
      t.string :currency

      t.timestamps
    end
  end
end
