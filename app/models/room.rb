class Room < ApplicationRecord
  before_create :generate_room_hash

  def self.random_room
    self.limit(1).order("RANDOM()").take
  end

  private
    def generate_room_hash
      self.room_hash = SecureRandom.hex
    end
end
