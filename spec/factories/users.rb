FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    provider     "facebook"
    provider_uid "100001513437149"
    screen_name  "user_screenname"
    name         "user"
    email        { generate(:email) }
    birthday     "2012-05-07 06:05:13"
    introduction "hello"
    education    "edu"
    work         "work"
    auth_token   "AAADuw16i74YBADtDA07hnmIcoLRHVCAnyUWFDAz2g4rZCxg0EWzCZAYL0tG7ZBAWuUbchhonZC88j8gbBkeYHCx8o0Bgzzju5oZCwg27ZC31ubikLCVupH"
    device_token nil
  end
end
