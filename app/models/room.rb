# frozen_string_literal: true

class Room < ApplicationRecord
  validates :room_hash, uniqueness: true
  after_initialize :generate_room_hash

  has_many :jams, dependent: :destroy

  def to_param
    room_hash
  end

  private

  def generate_room_hash
    self.room_hash ||= SecureRandom.hex
  end
end
