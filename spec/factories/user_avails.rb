# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_avail do
    user
    area
    avail_from   "11:00:00"
    avail_to     "14:00:00"
    avail_option "lunch"
  end
end
