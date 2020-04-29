# frozen_string_literal: true

class Invite < ApplicationRecord
  EXPIRES = 1.month.freeze

  belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :group

  validates :recipient, presence: true
  validate :recipient_not_in_group

  after_initialize :set_expires_at
  after_initialize :generate_invite_token

  scope :unexpired, -> { where(expires_at: Time.current..) }

  private

  def recipient_not_in_group
    return unless recipient.present?

    if recipient.in_group?(group)
      errors.add(:recipient, 'is already in the group')
    end
  end

  def set_expires_at
    self.expires_at ||= EXPIRES.ago
  end

  def generate_invite_token
    # Generate a token that doesn't already exist in the database
    _, encoded_token = Devise.token_generator.generate(Invite, :invite_token)
    self.invite_token = encoded_token
  end
end
