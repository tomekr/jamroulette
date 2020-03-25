# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: %i[show update]
  # GET /rooms/:room_hash
  def show
    @jams = @room.jams.order('jams.created_at DESC').to_a
    @current_jam = @jams.shift
    @new_jam = @room.jams.build
  end

  # POST /rooms
  def create
    room = Room.create!
    redirect_to room_path(room), notice: 'Room was successfully created.'
  end

  private

  def set_room
    @room = Room.find_by!(room_hash: params[:id])
  end
end
