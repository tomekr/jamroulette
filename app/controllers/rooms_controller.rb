# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: :show
  skip_before_action :authenticate_user!, only: :show

  # GET /rooms/:public_id
  def show
    @jams = @room.jams.last(20).to_a
    @current_jam = @jams.shift
    @new_jam = @room.jams.build
  end

  # POST /rooms
  def create
    room = Room.new(room_parms)

    if room.save
      room.activities.create!(user: current_user)
      redirect_to room_path(room)
    else
      flash.alert = room.errors.full_messages.join(', ')
      redirect_back fallback_location: home_path
    end
  end

  private

  def room_parms
    params.require(:room).permit(:name)
  end

  def set_room
    @room = Room.find_by!(public_id: params[:id])
  end
end
