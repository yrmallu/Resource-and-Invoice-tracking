class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :company_id
      t.string :name
      t.string :website
      t.text :description
      t.string :address
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
