FactoryBot.define do
  factory :user do
    display_name { "Bobby" }
    email { "bob@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Date.today }
  end
end
