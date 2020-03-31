# frozen_string_literal: true

class Room < ApplicationRecord
  validates :public_id, uniqueness: true
  validates :name, presence: true
  after_initialize :generate_public_id

  belongs_to :user, optional: true

  has_many :jams, dependent: :destroy
  has_many :activities, as: :subject, dependent: :destroy

  scope :recommended, -> { joins(:jams).order("RANDOM()") }

  def to_param
    public_id
  end

  private

  def generate_public_id
    self.public_id ||= SecureRandom.hex
  end
end
