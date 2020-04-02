class NotificationsController < ApplicationController
  before_action :set_room

  def index
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end

  def read
    @notifications.update_all(read_at: Time.now)

    respond_to do |format|
      format.json { render json: "OK" }
    end
  end

  private

  def set_room
    @notifications = current_user.notifications.unread
  end
end
