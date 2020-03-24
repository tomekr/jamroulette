# frozen_string_literal: true

class Jam < ApplicationRecord
  belongs_to :room
  has_one_attached :file
  validates :file, presence: true

  before_create :extract_filename

  private

  def extract_filename
    self.filename = self.file.blob.filename
  end
end
