# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:public_id/jams
  def create
    room = Room.find_by!(public_id: params[:room_id])
    jam = room.jams.build(file: jam_params[:file])

    # Set Jam tags
    jam.bpm_list = jam_params[:bpm]
    jam.song_key_list = jam_params[:song_key]
    jam.jam_type_list = jam_params[:jam_type]
    jam.style_list = jam_params[:style_list]
    jam.could_use_list = jam_params[:could_use_list]

    jam.user = current_user

    if jam.save
      NotificationService.notify_on_jam_creation(jam, current_user)
      flash[:success] = 'Jam successfully created!'
    else
      flash[:danger] = jam.errors.full_messages.join(', ')
    end
    redirect_to room_path(room)
  end

  private

  def jam_params
    params.require(:jam).permit(:file, :bpm, :song_key, :jam_type, :style_list, :could_use_list)
  end
end
