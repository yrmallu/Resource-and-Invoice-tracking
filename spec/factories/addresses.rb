# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    client_id 1
    street "MyString"
    city "MyString"
    state "MyString"
    country "MyString"
    zip_code 502032
    telephone_number 9667833175
    mobile 7893303939
    fax_no 1
    address_type "MyString"
  end
end