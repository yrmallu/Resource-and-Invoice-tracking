class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.string :domain
      t.string :telephone_number
      t.string :mobile
      t.string :image_name
      t.string :image_type
      t.boolean :delete_flag

      t.timestamps
    end
  end
end
