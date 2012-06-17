# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    name         "username"
    email        { generate(:email) }
    provider     "MyString"
    provider_uid 1
    auth_token   "MyString"
    birthday     "2012-06-10 22:33:44"
    introduction "MyText"
    education    "Education"
    work         "Work"
  end

  factory :meetup do
    title "MyString"
    user
    begin_at "2012-06-11 08:26:45"
    end_at "2012-06-11 08:26:45"
    public false
  end
end
