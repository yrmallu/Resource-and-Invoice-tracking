class RemoveDescriptionFromTimesheets < ActiveRecord::Migration
  def change
    remove_column :timesheets, :description, :text
  end
end
