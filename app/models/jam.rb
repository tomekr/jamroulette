# frozen_string_literal: true

class Jam < ApplicationRecord
  include Trackable
  acts_as_taggable_on :bpm, :song_key, :jam_type, :duration, :styles, :could_use

  belongs_to :room
  belongs_to :user
  has_one_attached :file
  validates :file, presence: { message: 'must be attached' }
  validates :jam_type, inclusion: { in: %w[Mix Solo Idea] }, allow_blank: true

  validate :content_type_is_audio
  validate :promotable

  has_many :activities, as: :subject, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy

  before_save :make_midi_solo
  before_create :promote_if_promotable

  scope :recent, -> { where(promoted_at: 30.days.ago..) }

  def bpm
    bpm_list.first
  end

  def song_key
    song_key_list.first
  end

  def jam_type
    jam_type_list.first
  end

  def duration
    duration_list.first
  end

  def midi?
    ['audio/midi', 'audio/x-midi'].include?(file.content_type)
  end

  def idea?
    jam_type == 'Idea'
  end

  def mix?
    jam_type == 'Mix'
  end

  def promote
    update(promoted_at: Time.current)
  end

  private

  def promotable
    return unless promoted_at?

    unless mix? || idea?
      errors.add(:base, 'Only Mixes and Ideas can be promoted')
    end
  end

  def promote_if_promotable
    self.promoted_at = Time.current if mix?
  end

  def make_midi_solo
    self.jam_type_list = 'Solo' if midi?
  end

  def content_type_is_audio
    return unless file.attached?

    unless file.content_type.match(%r{\Aaudio/*})
      errors.add(:file, 'must be an audio file')
    end
  end
end
