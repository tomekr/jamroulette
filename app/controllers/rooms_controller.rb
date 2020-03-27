# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: %i[show update]
  # GET /rooms/:public_id
  def show
    @jams = @room.jams.last(20).to_a
    @current_jam = @jams.shift
    @new_jam = @room.jams.build
  end

  # POST /rooms
  def create
    room = Room.create!
    redirect_to room_path(room)
  end

  def random_room
    redirect_to room_path(Room.random_room)
  end

  private

  def set_room
    @room = Room.find_by!(public_id: params[:id])
  end
end
