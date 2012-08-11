# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :oauth_user do
    provider     "facebook"
    provider_uid 100000
    auth_token   "auth_token"
  end
end
