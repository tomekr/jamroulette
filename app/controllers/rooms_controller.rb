# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: %i[show update]
  # GET /rooms/:room_hash
  def show
    @jams = @room.jams.order('jams.created_at DESC').to_a
    @current_jam = @jams.shift
  end

  # POST /rooms
  def create
    @room = Room.new

    if @room.save
      redirect_to room_path(@room.room_hash), notice: 'Room was successfully created.'
    else
      redirect_to room_path, alert: 'An error occured creating a new room'
    end
  end

  def update
    if params[:jam]
      @jam = @room.jams.build
      file = params[:jam][:file]

      @jam.file.attach(file)
      @jam.filename = file.original_filename
      @jam.save
    end
    redirect_to room_path(@room.room_hash)
  end

  private

  def set_room
    @room = Room.find_by_room_hash!(params[:room_hash])
  end
end
