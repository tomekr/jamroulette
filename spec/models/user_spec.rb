# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'Validations' do
    it 'is valid out of the factory' do
      expect(user).to be_valid
    end
  end

  describe '#in_group?' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    it 'returns true if user is a member of a group' do
      group.add(user)
      expect(user.in_group?(group)).to be true
    end

    context 'as owner' do
      it 'returns true if in group' do
        group.add_owner(user)
        expect(user.in_group?(group, as: :owner)).to be true
      end

      it 'returns false if user is a member but not an owner' do
        group.add(user)
        expect(user.in_group?(group, as: :owner)).to be false
      end

      it 'return false if user is not in the group as owner' do
        expect(user.in_group?(group, as: :owner)).to be false
      end
    end

    it 'returns false if group is not present' do
      expect(user.in_group?(nil)).to be false
    end

    it 'return false if user is not in the group' do
      expect(user.in_group?(group)).to be false
    end
  end
end
