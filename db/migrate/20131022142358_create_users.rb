class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :firstname
      t.string :lastname
      t.string :user_type
      t.string :skype_id
      t.string :hangout_id
      t.string :emp_code
      t.string :gender
      t.integer :role_id
      t.integer :boss_id
      t.integer :department_id
      t.date :joining_date
      t.float :experience
      t.string :technology
      t.string :education
      t.date :date_of_birth
      t.boolean :delete_flag
      t.boolean :access_flag
	
	  
      t.timestamps
    end
  end
end
