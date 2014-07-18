class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.integer :client_id
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :telephone_number
      t.string :mobile
      t.string :fax_no
      t.string :address_type

      t.timestamps
    end
  end
end
