# frozen_string_literal: true

FactoryBot.define do
  factory :jam do
    file { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg') }
    bpm_list { ['120'] }
    song_key_list { ['A Major'] }
    jam_type_list { ['MIX'] }
    style_list { ['Electronic', 'Lofi'] }
    could_use_list { ['Bass', 'Drums'] }

    room
    user
  end
end
