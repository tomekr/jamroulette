# frozen_string_literal: true

class Jam < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_one_attached :file
  validates :file, presence: { message: "must be attached" }
  validate :content_type_is_audio

  has_many :activities, as: :subject, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy

  after_create :create_activity

  private

  def create_activity
    activities.create!(user: user)
  end

  def content_type_is_audio
    return unless file.attached?

    unless file.content_type.match(/\Aaudio\/*/)
      errors.add(:file, "must be an audio file")
    end
  end
end
