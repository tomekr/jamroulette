# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:room_hash/jams
  def create
    room = Room.find_by!(room_hash: params[:room_id])
    jam = room.jams.build(jam_params)
    if jam.save
      flash[:success] = 'Jam successfully created!'
    else
      flash[:danger] = 'A file must be specified.'
    end
    redirect_to room_path(room)
  end

  private

  def jam_params
    params.require(:jam).permit(:bpm, :file)
  end
end
