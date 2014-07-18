# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
      email "valid@gmail.com"
      password "ammananna"
      password_confirmation "ammananna"
      firstname "Reddy"
      lastname "mallu"
      user_type "employee"
      skype_id "1234"
      emp_code "cue131"
      gender "male"
      boss_id 1
      role_id 1
      department_id 1
      joining_date "2013-09-12"
      experience "2.4"
      technology "ROR"
      education "B.Tech"
      date_of_birth "1990-08-31"
      delete_flag 0
	  is_admin true
  end
end