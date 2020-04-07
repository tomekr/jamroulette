require 'rails_helper'

RSpec.describe RoomsHelper, type: :helper do
  describe '#jam_user' do
    context 'user exists' do
      it 'returns the users display name' do
        user = build(:user, display_name: 'Bobby')
        jam = build(:jam, user: user)

        expect(helper.jam_user(jam)).to eq('Bobby')
      end
    end

    context 'user does not exist' do
      it 'returns Anonymous' do
        jam = build(:jam, user: nil)

        expect(helper.jam_user(jam)).to eq('Anonymous')
      end
    end
  end

  describe '#format_duration' do
    it 'returns duration in formated time' do
      expect(helper.format_duration('90')).to eq('01:30')
    end

    it 'returns Unavailable if a duration does not exist' do
      expect(helper.format_duration(nil)).to eq('Unavailable')
    end
  end
end
