require "rails_helper"

describe ActivityPresenter do
  let(:room) { build(:room, public_id: 'activity-presenter-room') }
  let(:presenter) { ActivityPresenter.new(activity) }

  context 'presenting a jam' do
    let(:jam) { build(:jam, room: room) }
    let(:activity) { create(:activity, :room, subject: jam) }

    it "displays filename and room link" do
      allow(activity).to receive(:subject_type).and_return("Jam")
      expect(presenter.activity_feed_line).to eq(
        "<span class='jam-activity'>You uploaded test.mp3 to <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a></span>"
      )
    end
  end

  context 'presenting a room' do
    let(:activity) { create(:activity, :room, subject: room) }

    it "displays the room link" do
      allow(activity).to receive(:subject_type).and_return("Room")
      expect(presenter.activity_feed_line).to eq(
        "<span class='room-activity'>You created <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a></span>"
      )
    end
  end
end
