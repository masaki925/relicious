# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    name         "username"
    email        { generate(:email) }
    birthday     "2012-06-10"
    introduction "MyText"
    education    "Education"
    work         "Work"
    gender       "male"
    locale       "en_US"
    location     "Tokyo"
    favorite_food "favorite food"
    ng_food      "ng food"
    nationality  "JP"
    active       true
  end
end
