class IsVerifiedToProjectContacts < ActiveRecord::Migration
  def change
    add_column :project_contacts, :is_verified, :boolean, :default=>false
  end
end
