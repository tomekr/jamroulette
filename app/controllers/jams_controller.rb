# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:public_id/jams
  def create
    room = Room.find_by!(public_id: params[:room_id])
    jam = room.jams.build(jam_params)

    jam.user = current_user

    if jam.save
      jam.activities.create!(user: current_user)
      flash[:success] = 'Jam successfully created!'
      JamMailer.jam_uploaded_email(jam).deliver_later

      #TODO move this to Room#contributors (possibly into a scope?)
      contributors = jam.room.jams.map(&:user).select do |user|
        user != jam.room.user && user != jam.user
      end

      contributors.each do |contributor|
        JamMailer.jam_uploaded_contributor_email(jam, contributor).deliver_later
      end
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
