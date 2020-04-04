# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg') }
    bpm { '120' }
    song_key_list { ['A Major'] }
    style_list { ['Electronic', 'Lofi'] }
    could_use_list { ['Bass', 'Drums'] }

    room
    user
  end
end
