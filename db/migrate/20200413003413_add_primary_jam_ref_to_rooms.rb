# frozen_string_literal: true

class AddPrimaryJamRefToRooms < ActiveRecord::Migration[6.0]
  def up
    add_reference :rooms, :primary_jam

    Room.all.each do |room|
      primary_jam = room.jams.where.not(promoted_at: nil).order(promoted_at: :desc).first
      room.update(primary_jam: primary_jam)
      puts "Room #{room.id} updated with primary_jam: #{room.primary_jam&.id}"
    end
  end

  def down
    remove_reference :rooms, :primary_jam
  end
end
