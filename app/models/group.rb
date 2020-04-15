# frozen_string_literal: true

class Group < ApplicationRecord
  groupify :group, default_members: :users
  # has_many :owners, through: :group_memberships, source: :user
  # has_many :users, through: :group_memberships
  # has_many :group_members, dependent: :destroy
end
