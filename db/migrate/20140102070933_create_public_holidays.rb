class CreatePublicHolidays < ActiveRecord::Migration
  def change
    create_table :public_holidays do |t|
      t.string :name
      t.date :holiday_date
      t.integer :company_id
      t.timestamps
    end
  end
end
