class ChangeDateTypeInUsers < ActiveRecord::Migration
  def up
   change_column :users, :technology, :text
  end

  def down
   change_column :users, :technology, :string
  end
end
