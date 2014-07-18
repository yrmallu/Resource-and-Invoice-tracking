class AddImageTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_type, :string
  end
end
