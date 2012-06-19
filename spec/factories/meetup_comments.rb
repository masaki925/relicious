# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meetup_comment do
    user
    meetup
    body "MyText"
  end
end
