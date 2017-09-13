# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :library do
    name { Faker::Company.name }
    # account
    # creator { account.owner if account }

    factory :invalid_library do
      name nil
    end
  end
end
