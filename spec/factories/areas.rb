# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :area_name do |n|
    "area#{n}"
  end

  factory :area do
    name { generate(:area_name) }
  end
end
