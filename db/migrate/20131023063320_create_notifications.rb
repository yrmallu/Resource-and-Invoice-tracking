class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :notification_type
      t.text :template
      t.text :description

      t.timestamps
    end
  end
end
