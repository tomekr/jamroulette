# frozen_string_literal: true

class Jam < ApplicationRecord
  include Trackable
  acts_as_taggable_on :bpm, :song_key, :jam_type, :duration, :styles, :could_use

  belongs_to :room
  belongs_to :user
  has_one_attached :file
  validates :file, presence: { message: "must be attached" }
  validate :content_type_is_audio

  validates :jam_type, inclusion: { in: %w[Mix Solo Idea] }, allow_blank: true

  has_many :activities, as: :subject, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy

  before_create :make_midi_solo

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

  private

  def make_midi_solo
    if ['audio/midi', 'audio/x-midi'].include?(file.content_type)
      self.jam_type_list = "Solo"
    end
  end

  def content_type_is_audio
    return unless file.attached?

    unless file.content_type.match(/\Aaudio\/*/)
      errors.add(:file, "must be an audio file")
    end
  end
end
