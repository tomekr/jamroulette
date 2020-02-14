class RoomsController < ApplicationController
  before_action :set_room, only: [:show]

  # POST /rooms
  def create
    @room = Room.new
    @room.title = Faker::Music.band

    if @room.save
      redirect_to room_path(@room.room_hash), notice: 'Room was successfully created.'
    else
      redirect_to room_path, alert: "An error occured creating a new room"
    end
  end

  def show
  end

  def random_room
    @room = Room.random_room
    redirect_to room_path(@room.room_hash)
  end

  private
    def set_room
      @room = Room.find_by(room_hash: params[:room_hash])
    end
end
