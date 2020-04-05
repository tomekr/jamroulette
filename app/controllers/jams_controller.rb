# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:public_id/jams
  def create
    room = Room.find_by!(public_id: params[:room_id])
    jam = room.jams.build(jam_params)

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
    params.require(:jam).permit(
      :file, :bpm_list, :song_key_list,
      :jam_type_list, :style_list, :could_use_list
    )
  end
end
