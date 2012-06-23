# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    name         "username"
    email        { generate(:email) }
    provider     "facebook"
    provider_uid 100
    auth_token   "MyString"
    birthday     "2012-06-10"
    introduction "MyText"
    education    "Education"
    work         "Work"
    location     "Location"
  end
end
