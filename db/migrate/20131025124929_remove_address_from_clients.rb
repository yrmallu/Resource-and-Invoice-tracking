class RemoveAddressFromClients < ActiveRecord::Migration
  def change
   remove_column :clients, :address
  end
end
