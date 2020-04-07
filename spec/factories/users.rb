FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    display_name { 'Bobby' }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Date.today }
  end
end
