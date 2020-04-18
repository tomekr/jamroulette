# frozen_string_literal: true

class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
