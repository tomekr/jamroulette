# frozen_string_literal: true

class JamsController < ApplicationController
  before_action :authenticate_user!

  # POST /rooms/:public_id/jams
  def create
    room = Room.find_by!(public_id: params[:room_id])
    jam = room.jams.build(jam_params)

    if user_signed_in?
      jam.user = current_user
    end

    if jam.save
      flash[:success] = 'Jam successfully created!'
    else
      flash[:danger] = jam.errors.full_messages.join(', ')
    end
    redirect_to room_path(room)
  end

  private

  def jam_params
    params.require(:jam).permit(:bpm, :file)
  end
end
