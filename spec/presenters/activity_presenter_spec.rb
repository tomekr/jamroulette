require "rails_helper"

describe ActivityPresenter do
  include ActionView::TestCase::Behavior

  let(:room) { build(:room, public_id: 'activity-presenter-room') }
  let(:presenter) { ActivityPresenter.new(activity, view) }

  context 'presenting a jam' do
    let(:jam) { build(:jam, room: room) }
    let(:activity) { create(:activity, :room, subject: jam) }

    it 'returns correct type' do
      expect(presenter.type).to eq('jam')
    end

    it 'returns a message' do
      expect(presenter.message).to eq(
        "You uploaded <i class=\"fas fa-music\"></i> test.mp3 to <i class=\"fas fa-door-open\"></i> <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a>"
      )
    end
  end

  context 'presenting a room' do
    let(:activity) { create(:activity, :room, subject: room) }

    it 'returns correct type' do
      expect(presenter.type).to eq('room')
    end

    it 'returns a message' do
      expect(presenter.message).to eq(
        "You created <i class=\"fas fa-door-open\"></i> <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a>"
      )
    end
  end
end
