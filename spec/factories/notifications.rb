FactoryBot.define do
  factory :notification do
    user
    association :actor, factory: :user

    trait :jam do
      notify_type { "jam_created" }
      association :target, factory: :jam
    end
  end
end
