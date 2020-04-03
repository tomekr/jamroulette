class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }
end
