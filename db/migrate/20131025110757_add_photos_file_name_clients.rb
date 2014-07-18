class AddPhotosFileNameClients < ActiveRecord::Migration
  def change
    add_column :clients, :photos_file_name, :string
    add_column :clients, :photos_content_type, :string
    add_column :clients, :photos_file_size, :string
    add_column :clients, :photos_updated_at, :datetime
  end
end
