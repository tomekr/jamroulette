# frozen_string_literal: true

class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  scope :as, lambda { |membership_type|
    where(group_memberships: { membership_type: membership_type })
  }
end
