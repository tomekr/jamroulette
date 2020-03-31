require "rails_helper"

RSpec.describe RoomsHelper, :type => :helper do
  describe "#jam_user" do
    context "user exists" do
      it "returns the users display name" do
        user = build(:user, display_name: "Bobby")
        jam = build(:jam, user: user)

        expect(helper.jam_user(jam)).to eq("Bobby")
      end
    end

    context "user does not exist" do
      it 'returns Anonymous' do
        jam = build(:jam, user: nil)

        expect(helper.jam_user(jam)).to eq("Anonymous")
      end
    end
  end
end
