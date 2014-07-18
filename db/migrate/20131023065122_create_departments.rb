class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :company_id
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
