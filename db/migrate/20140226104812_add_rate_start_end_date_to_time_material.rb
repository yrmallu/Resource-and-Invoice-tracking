class AddRateStartEndDateToTimeMaterial < ActiveRecord::Migration
  def change
    add_column :time_materials, :rate_start_date, :date
    add_column :time_materials, :rate_end_date, :date
    add_column :time_materials, :is_active, :boolean
  end
end
