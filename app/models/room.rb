# frozen_string_literal: true

class Room < ApplicationRecord
  validates :public_id, uniqueness: true
  after_initialize :generate_public_id

  has_many :jams, dependent: :destroy

  def to_param
    public_id
  end

  def self.random_room
    self.limit(1).order("RANDOM()").take
  end

  private

  def generate_public_id
    self.public_id ||= SecureRandom.hex
  end
end
