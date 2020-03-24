class StaticController < ApplicationController
  def index
    room_hash = params[:room_hash]

    Room.first.where("room_hash = '" + room_hash + "'")
  end
end
