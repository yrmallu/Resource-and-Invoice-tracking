class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
