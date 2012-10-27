# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_meetup_permission do
    user
    meetup
    status MEETUP_STATUS_INVITED
  end
end
