# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| Faker::Internet.email + n.to_s }
    password "YoucaLLthatapa$$word"
    activated true
    password_reset_date DateTime.now.to_date

    factory :unactivated_user do
      activated false
    end
    
    factory :invalid_user do
      email nil
    end
  end
end
