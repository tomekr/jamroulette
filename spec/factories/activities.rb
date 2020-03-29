FactoryBot.define do
  factory :activity do
    user

    trait :jam do
      association :subject, factory: :jam
    end

    trait :room do
      association :subject, factory: :room
    end
  end
end
