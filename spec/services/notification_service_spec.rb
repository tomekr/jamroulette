require 'rails_helper'

RSpec.describe NotificationService do
  let(:jam) { create(:jam) }
  let(:user) { create(:user) }

  describe '.notify' do
    it 'creates a notification' do
      expect do
        NotificationService.notify(subject: jam, user: user, event: :jam_created)
      end.to change(Notification, :count).by(1)
    end
  end

  describe '.notify_on_jam_creation' do
    let(:room) { create(:room) }
    let(:uploader) { create(:user) }
    let(:jam) { create(:jam, room: room, user: uploader) }

    it 'does not send a notification to the actor' do
      expect do
        NotificationService.notify_on_jam_creation(jam, uploader)
      end.to_not change(Notification, :count)
    end

    context 'contributor uploaded multiple jams' do
      before { create_list(:jam, 2, room: room, user: user) }

      it 'does not send contributor multiple notifications' do
        NotificationService.notify_on_jam_creation(jam, user)

        expect do
          NotificationService.notify_on_jam_creation(jam, uploader)
        end.to change(Notification, :count).by(1)
      end
    end
  end
end
