class AddCommittedHoursToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :committed_hours, :integer
  end
end
