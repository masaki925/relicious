# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meetup do
    title "Title"
    user
    area
    begin_at "2012-06-11 08:26:45"
    end_at "2012-06-11 08:26:45"
    public false
    place  "Shibuya"
    url    "http://relicious.me/"
    description "description"
    fixed  false
  end

  factory :meetup_without_mass_assign, class: Meetup do
    title "Title"
    user
    area
    begin_at "2012-06-11 08:26:45"
    end_at "2012-06-11 08:26:45"
    public false
    place  "Shibuya"
    url    "http://relicious.me/"
    description "description"
  end
end
