# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    group
    association :recipient, factory: :user
    association :sender, factory: :user

    invite_token { 'secret-invite-token' }
    role { 'Member' }

    trait :expired do
      expires_at { 1.hour.ago }
    end

    trait :owner_invite do
      role { 'Owner' }
    end
  end
end
