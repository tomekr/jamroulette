# frozen_string_literal: true

class JamsController < ApplicationController
  # POST /rooms/:room_hash/jams
  def create
    room = Room.find_by!(room_hash: params[:room_id])
    if params[:jam]
      jam = room.jams.build
      file = params[:jam][:file]

      jam.file.attach(file)
      jam.filename = file.original_filename

      jam.bpm = params[:jam][:bpm] unless params[:jam][:bpm].blank?
      jam.save
    end
    redirect_to room_path(room)
  end
end
