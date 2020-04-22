# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  validates :name, presence: true

  scope :discoverable, -> { where(visible: true) }
  scope :as, lambda { |membership_type|
    joins(:group_memberships).where(
      group_memberships: { membership_type: membership_type }
    )
  }

  def add_owner(user)
    user.group_memberships.create(membership_type: :owner, group: self)
  end

  def add(user)
    group_memberships.create!(user: user)
  end

  def members
    users
  end
end
