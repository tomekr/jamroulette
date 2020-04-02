require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Validations' do
    let(:notification) { build(:notification, :jam) }

    it 'is valid out of the factory' do
      expect(notification).to be_valid
    end
  end
end
