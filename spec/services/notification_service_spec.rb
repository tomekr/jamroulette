require "rails_helper"

RSpec.describe NotificationService do
  describe '.notify' do
    let(:jam) { create(:jam) }
    let(:user) { create(:user) }

    it 'creates a notification' do
      expect do
        NotificationService.notify(subject: jam, user: user, event: :jam_created)
      end.to change(Notification, :count).by(1)
    end
  end
end
