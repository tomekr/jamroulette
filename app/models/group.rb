# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :invites, dependent: :destroy

  validates :name, presence: true

  scope :discoverable, -> { where(visible: true) }

  scope :as, lambda { |membership_type|
    joins(:group_memberships).merge(GroupMembership.as(membership_type))
  }

  def add_owner(user)
    group_memberships.create!(user: user, membership_type: :owner)
  end

  def add(user)
    group_memberships.create!(user: user)
  end

  def members
    users
  end
end
