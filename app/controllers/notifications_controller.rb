class NotificationsController < ApplicationController
  before_action :set_room

  def index
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end

  private

  def set_room
    @notifications = current_user.notifications
  end
end
