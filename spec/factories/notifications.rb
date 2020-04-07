FactoryBot.define do
  factory :notification do
    user

    # Default to creating a jam
    event { 'jam_created' }
    association :target, factory: :jam

    trait :jam do
      event { 'jam_created' }
      association :target, factory: :jam
    end
  end
end
