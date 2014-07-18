class AddIsBillableToProjectContacts < ActiveRecord::Migration
  def change
    add_column :project_contacts, :is_billable, :boolean
  end
end
