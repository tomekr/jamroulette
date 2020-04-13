# frozen_string_literal: true

class Room < ApplicationRecord
  include Trackable

  validates :public_id, uniqueness: true
  validates :name, presence: true
  after_initialize :generate_public_id

  belongs_to :user

  has_many :jams, dependent: :destroy
  has_many :users, through: :jams

  has_many :activities, as: :subject, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy

  scope :recommended, -> { joins(:jams).order('RANDOM()') }

  def self.primary_with_could_use
    jams = ActsAsTaggableOn::Tagging.where(
      taggable_type: 'Jam',
      context: 'could_use'
    ).map(&:taggable).uniq

    room_ids = jams.select { |jam| jam == jam.room.primary_jam }.map(&:room_id)

    # Return an ActiveRecord Relation for pagination
    Room.where(id: room_ids)
  end

  def to_param
    public_id
  end

  def primary_jam
    jams.where.not(promoted_at: nil).order(promoted_at: :desc).first
  end

  private

  def generate_public_id
    self.public_id ||= SecureRandom.hex
  end
end
