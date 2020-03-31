# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    bpm { '120' }
    file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg') }
    room
    user
  end
end
