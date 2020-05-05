# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'Validations' do
    it 'is valid out of the factory' do
      expect(user).to be_valid
    end
  end

  context 'destroying a user' do
    it 'destroys associated invites as a recipient' do
      recipient = create(:invite).recipient

      expect do
        recipient.destroy
      end.to change(Invite, :count).from(1).to(0)
    end

    it 'destroys associated invites as a sender' do
      sender = create(:invite).sender

      expect do
        sender.destroy
      end.to change(Invite, :count).from(1).to(0)
    end
  end

  describe '#in_group?' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    example 'member of group' do
      group.add(user)
      expect(user.in_group?(group)).to be true
    end

    example 'nil group' do
      expect(user.in_group?(nil)).to be false
    end

    example 'not a member of group' do
      expect(user.in_group?(group)).to be false
    end

    context 'as owner' do
      example 'member and owner of group' do
        group.add_owner(user)
        expect(user.in_group?(group, as: :owner)).to be true
      end

      example 'member of group but not owner' do
        group.add(user)
        expect(user.in_group?(group, as: :owner)).to be false
      end

      example 'not a member of group' do
        expect(user.in_group?(group, as: :owner)).to be false
      end
    end
  end
end
