# frozen_string_literal: true

class Jam < ApplicationRecord
  include Trackable
  acts_as_taggable_on :bpm, :song_key, :jam_type, :styles, :could_use

  belongs_to :room
  belongs_to :user
  has_one_attached :file
  validates :file, presence: { message: "must be attached" }
  validate :content_type_is_audio
  validate :jam_type_supported

  has_many :activities, as: :subject, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy

  def bpm
    bpm_list.first
  end

  def song_key
    song_key_list.first
  end

  def jam_type
    jam_type_list.first
  end

  private

  def jam_type_supported
    return unless jam_type

    unless  ['Mix', 'Solo', 'Idea'].include?(jam_type)
      errors.add(:jam_type, "must be Mix, Solo, or Idea")
    end
  end

  def content_type_is_audio
    return unless file.attached?

    unless file.content_type.match(/\Aaudio\/*/)
      errors.add(:file, "must be an audio file")
    end
  end
end
