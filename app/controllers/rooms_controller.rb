class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update]

  # GET /rooms/:room_hash
  def show
  end

  # GET /rooms/random_room
  def random_room
    @room = Room.random_room
    redirect_to room_path(@room.room_hash)
  end

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
  
  # PATCH/PUT /rooms/:room_hash
  def update
    if @room.update(room_params)
      redirect_to room_path(@room.room_hash), notice: 'Room was successfully updated.'
    else
      render :show
    end
  end

  private
    def room_params
      params.require(:room).permit(:jam)
    end

    def set_room
      @room = Room.find_by(room_hash: params[:room_hash])
    end
end
