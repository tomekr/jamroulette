class NotificationsController < ApplicationController
  before_action :set_notifications

  def index
    render json: @notifications
  end

  def read
    @notifications.update_all(read_at: Time.current)

    render json: 'OK'
  end

  private

  def set_notifications
    @notifications = current_user.notifications.unread
  end
end
