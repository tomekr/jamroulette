require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#bulma_flash_mapping" do
    it 'maps alert to danger' do
      expect(helper.bulma_flash_mapping('alert')).to eq('danger')
    end
  end

  # TODO Remove when beta invite code feature is removed
  describe "#beta_user?" do
    it 'returns true if beta user' do
      session[:is_beta_user] = true
      expect(helper.beta_user?).to be true
    end

    it 'returns false if not beta user' do
      session[:is_beta_user] = nil
      expect(helper.beta_user?).to be false
    end
  end
end
