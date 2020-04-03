module Trackable
  extend ActiveSupport::Concern

  included do
    after_create :create_activity
  end

  private

  def create_activity
    activities.create!(user: user)
  end
end
