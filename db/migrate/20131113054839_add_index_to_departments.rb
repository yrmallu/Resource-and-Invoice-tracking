class AddIndexToDepartments < ActiveRecord::Migration
  def change
    add_index :departments, :name, unique: true
  end
end
