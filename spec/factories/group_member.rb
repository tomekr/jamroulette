# frozen_string_literal: true

FactoryBot.define do
  factory :group_membership do
    group
    association :member, factory: :user

    trait(:owner) do
      membership_type { :owner }
    end
  end
end
