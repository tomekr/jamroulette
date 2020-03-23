# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    filename { 'the-darkest-of-toasters.wav' }
    bpm { '120' }
    room
  end
end
