class CreateProjectNotifications < ActiveRecord::Migration
  def change
    create_table :project_notifications do |t|
      t.integer :project_id
      t.integer :notification_id
      t.integer :user_id

      t.timestamps
    end
  end
end
