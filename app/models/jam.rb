# frozen_string_literal: true

class Jam < ApplicationRecord
  belongs_to :room
  has_one_attached :file
end
