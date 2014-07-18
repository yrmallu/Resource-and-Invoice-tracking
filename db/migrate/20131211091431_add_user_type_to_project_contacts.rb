class AddUserTypeToProjectContacts < ActiveRecord::Migration
  def change
    add_column :project_contacts, :user_type, :string
  end
end
