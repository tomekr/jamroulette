# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    name { 'Room 1' }
    user
  end
end
