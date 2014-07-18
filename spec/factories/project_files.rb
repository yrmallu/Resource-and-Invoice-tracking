# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_file do
    files_file_name "tt_left.gif"
    files_content_type "image/gif"
  end
end
