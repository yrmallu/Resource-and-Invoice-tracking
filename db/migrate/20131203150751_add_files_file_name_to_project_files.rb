class AddFilesFileNameToProjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :files_file_name, :string
    add_column :project_files, :files_content_type, :string
    add_column :project_files, :files_file_size, :string
    add_column :project_files, :files_updated_at, :datetime
  end
end
