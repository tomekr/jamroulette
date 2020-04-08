# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg') }
    jam_type_list { ['Mix'] }
    room
    user

    trait :idea do
      jam_type_list { ['Idea'] }
      file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'idea.mp3'), 'audio/mpeg') }
    end

    trait :solo do
      jam_type_list { ['Solo'] }
      file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'solo.mp3'), 'audio/mpeg') }
    end

    trait :mix do
      jam_type_list { ['Mix'] }
    end

    trait :with_tags do
      bpm_list { ['120'] }
      song_key_list { ['A Major'] }
      jam_type_list { ['Mix'] }
      duration_list { ['90'] }
      style_list { %w[Electronic Lofi] }
      could_use_list { %w[Bass Drums] }
    end
  end
end
