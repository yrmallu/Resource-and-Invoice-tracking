class AddPhotosFileNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photos_file_name, :string
    add_column :users, :photos_content_type, :string
    add_column :users, :photos_file_size, :string
    add_column :users, :photos_updated_at, :datetime
  end
end
