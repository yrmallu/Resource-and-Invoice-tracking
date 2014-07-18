class AddResourceTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :resource_type, :string
  end
end
