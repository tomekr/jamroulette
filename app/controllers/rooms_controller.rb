# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: :show
  skip_before_action :authenticate_user!, only: %i[show random]

  # GET /rooms/:public_id
  def show
    jams = @room.jams.last(20).reverse
    @primary_jam = @room.primary_jam
    @supporting_jams = jams - [@primary_jam]
    @new_jam = @room.jams.build
  end

  # POST /rooms
  def create
    room = current_user.rooms.build(room_parms)

    if room.save
      redirect_to room_path(room)
    else
      flash.alert = room.errors.full_messages.join(', ')
      redirect_back fallback_location: home_path
    end
  end

  # GET /rooms/random
  def random
    if (room = Room.recommended.take)
      redirect_to room
    else
      redirect_to home_path, alert: 'No rooms with a jam exist'
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
