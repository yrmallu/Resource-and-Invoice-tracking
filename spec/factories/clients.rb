# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    name "MyString"
    website "https://www.google.co.in/"
    company_id 1
    description "MyText"
  end
end
