# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { build(:group) }
  let(:user) { create(:user) }

  describe 'Validations' do
    it 'is valid out of the factory' do
      expect(group).to be_valid
    end

    it 'requires a group name' do
      group.name = ''
      expect(group).to_not be_valid
    end
  end

  context 'adding members to a group' do
    let(:group) { create(:group) }

    describe '#add_owner' do
      it 'adds a user to a group as an owner' do
        group.add_owner(user)
        expect(user.groups.as(:owner)).to contain_exactly group
      end
    end

    describe '#add' do
      it 'adds a user to a group' do
        group.add(user)
        expect(user.groups).to contain_exactly group
      end
    end

    describe '#members' do
      it 'lists the members of a group' do
        users = create_list(:user, 3)
        users.each { |user| group.add(user) }
        expect(group.members).to match_array users
      end
    end
  end

  describe '.as' do
    it 'returns groups with owners' do
      empty_group = create(:group)
      groups = create_list(:group, 3)

      groups.each { |group| group.add_owner(user) }

      expect(Group.as(:owner)).to match_array groups
    end
  end
end
