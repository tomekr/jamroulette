# frozen_string_literal: true

class Group < ApplicationRecord
  groupify :group, default_members: :users
  validates :name, presence: true

  # has_many :owners, through: :group_memberships, source: :user
  # has_many :users, through: :group_memberships
  # has_many :group_members, dependent: :destroy
  scope :discoverable, -> { where(visible: true) }

  def add_owner(user)
    add user, as: :owner
  end
end
