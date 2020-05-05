# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invite, type: :model do
  let(:invite) { build(:invite) }

  describe 'Validations' do
    it 'is valid out of the factory' do
      expect(invite).to be_valid
    end

    it 'is invalid if recipient already in group' do
      group = create(:group)
      recipient = create(:user)
      group.add(recipient)

      invite = build(:invite, group: group, recipient: recipient)
      expect(invite).to be_invalid
    end

    it 'is invalid if recipient already has unexpired invite' do
      create(:invite, group: invite.group, recipient: invite.recipient)

      expect(invite).to be_invalid
    end

    it 'validates precense of a recipient' do
      invite = build(:invite, recipient: nil)
      expect(invite).to be_invalid
    end

    it 'validates precense of a sender' do
      invite = build(:invite, sender: nil)
      expect(invite).to be_invalid
    end

    it 'validates precense of a group' do
      invite = build(:invite, group: nil)
      expect(invite).to be_invalid
    end
  end

  describe '.unexpired' do
    it 'returns unexpired invites' do
      create(:invite, :expired)
      invite.save
      expect(Invite.unexpired).to contain_exactly(invite)
    end
  end

  it 'sets expired_at to 1 month from now' do
    freeze_time do
      invite = Invite.new
      expect(invite.expires_at).to eq 1.month.from_now
    end
  end

  it 'generates an invite token' do
    invite = Invite.new
    expect(invite.invite_token).to match(/[A-Fa-f0-9]{64}/)
  end
end
