require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#bulma_flash_mapping" do
    it 'maps alert to danger' do
      expect(helper.bulma_flash_mapping('alert')).to eq('danger')
    end
  end
end
