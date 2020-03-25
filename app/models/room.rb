# frozen_string_literal: true

class Room < ApplicationRecord
  validates :room_hash, uniqueness: true, allow_nil: false
  before_create :generate_room_hash

  has_many :jams

  def to_param
    room_hash
  end

  private

  def generate_room_hash
    self.room_hash = SecureRandom.hex
  end
end
