# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupMembership, type: :model do
  describe '.as' do
    it 'returns owner group memberships' do
      group = create(:group)
      members = create_list(:user, 2)
      members.each { |member| group.add(member) }

      owner = create(:user)
      group.add_owner(owner)
      owner_membership = owner.group_memberships.last

      expect(GroupMembership.as(:owner)).to contain_exactly(owner_membership)
    end
  end
end
