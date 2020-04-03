# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:public_id/jams
  def create
    room = Room.find_by!(public_id: params[:room_id])
    jam = room.jams.build(jam_params)

    jam.user = current_user

    if jam.save
      room.users.reject{|user| user == current_user }.each do |user|
        NotificationService.notify(
          subject: jam,
          user: user,
          event: :jam_created
        )
      end

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
