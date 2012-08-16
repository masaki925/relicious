# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meetup do
    title "Title"
    user
    begin_at "2012-06-11 08:26:45"
    end_at "2012-06-11 08:26:45"
    area
    public false
  end
end
