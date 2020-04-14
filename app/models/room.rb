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
    Room
      .includes(:jams)
      .joins(:jams)
      .merge(Jam.recent)
      .merge(
        Jam.tagged_with(
          ActsAsTaggableOn::Tag.for_context(:could_use), on: :could_use, any: true
        )
      )
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
