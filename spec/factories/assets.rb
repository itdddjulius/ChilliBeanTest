# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset do
    filename "file.mp4"
    filesize 500
    file_id "123456"
    file_type :video
    s3_name 'example/path/to/file.mp4'

    association :library
    association :uploader, factory: :user
  end
end
