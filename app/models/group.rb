# frozen_string_literal: true

class Group < ApplicationRecord
  groupify :group, default_members: :users
  validates :name, presence: true

  scope :discoverable, -> { where(visible: true) }

  def add_owner(user)
    add user, as: :owner
  end
end
