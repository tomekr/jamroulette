# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg') }
    room
    user

    trait :with_tags do
      bpm_list { ['120'] }
      song_key_list { ['A Major'] }
      jam_type_list { ['Mix'] }
      duration_list { ['90'] }
      style_list { ['Electronic', 'Lofi'] }
      could_use_list { ['Bass', 'Drums'] }
    end
  end
end
