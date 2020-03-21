# frozen_string_literal: true

class Room < ApplicationRecord
  validates :room_hash, uniqueness: true, allow_nil: false
  before_create :generate_room_hash

  private

  def generate_room_hash
    self.room_hash = SecureRandom.hex
  end
end
