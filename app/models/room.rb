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
  scope :with_jams, -> { joins(:jams) }

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
