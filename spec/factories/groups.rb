# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    visible { true }

    trait(:private) do
      visible { false }
    end
  end
end
