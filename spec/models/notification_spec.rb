require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Validations' do
    let(:notification) { build(:notification) }

    it 'is valid out of the factory' do
      expect(notification).to be_valid
    end
  end

  describe '.unread' do
    it 'returns a Notification that is unread' do
      create(:notification)
      expect(Notification.unread.take.read_at).to be nil
    end
  end
end
