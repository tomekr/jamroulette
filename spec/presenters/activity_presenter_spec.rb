require "rails_helper"

describe ActivityPresenter do
  # instance_double won't work for ActiveStorage::Attached::One since filename
  # is not an instance_method on that class.
  let(:file) { double(ActiveStorage::Attached::One, filename: 'test.mp3') }
  let(:room) { instance_double(Room, public_id: 'activity-presenter-room') }
  let(:jam) { instance_double(Jam, file: file, room: room) }

  let(:room_activity) { instance_double(Activity, subject: room) }
  let(:jam_activity) { instance_double(Activity, subject: jam) }

  let(:presenter) { ActivityPresenter.new(activity) }

  context 'presenting a jam' do
    let(:activity) { jam_activity }

    it "displays filename and room link" do
      allow(jam_activity).to receive(:subject_type).and_return("Jam")
      expect(presenter.activity_feed_line).to eq(
        "<span class='jam-activity'>You uploaded test.mp3 to <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a></span>"
      )
    end
  end

  context 'presenting a room' do
    let(:activity) { room_activity }

    it "displays the room link" do
      allow(room_activity).to receive(:subject_type).and_return("Room")
      expect(presenter.activity_feed_line).to eq(
        "<span class='room-activity'>You created <a href=\"/rooms/activity-presenter-room\">activity-presenter-room</a></span>"
      )
    end
  end
end
