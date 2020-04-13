# frozen_string_literal: true

class JamsController < ApplicationController
  before_action :set_room

  # POST /rooms/:public_id/jams
  def create
    jam = @room.jams.build(jam_params)
    jam.user = current_user

    if jam.save
      NotificationService.notify_on_jam_creation(jam, current_user)
      flash[:success] = 'Jam successfully created!'
    else
      flash[:danger] = jam.errors.full_messages.join(', ')
    end
    redirect_to room_path(@room)
  end

  # PUT /rooms/:public_id/jams/:id/promote
  def promote
    jam = @room.jams.find(params[:id])

    if jam.promote
      flash.notice = 'Jam has been promoted'
    else
      flash.alert = jam.errors.full_messages.join(', ')
    end
    redirect_to room_path(@room)
  end

  private

  def set_room
    @room = Room.find_by!(public_id: params[:room_id])
  end

  def jam_params
    params.require(:jam).permit(
      :file, :bpm_list, :song_key_list, :duration_list,
      :jam_type_list, :style_list, :could_use_list, :notes
    )
  end
end
