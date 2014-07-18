# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timematerial_milestone do
    project_id 1
    milestone_name "MyString"
    milestone_start_date "2014-02-26"
    milestone_end_date "2014-02-26"
    status "MyString"
    description "MyText"
    amount 1.5
    currency "MyString"
    reason "MyText"
  end
end
