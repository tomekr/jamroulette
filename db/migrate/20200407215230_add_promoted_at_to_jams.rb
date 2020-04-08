# frozen_string_literal: true

class AddPromotedAtToJams < ActiveRecord::Migration[6.0]
  def up
    add_column :jams, :promoted_at, :datetime, index: true

    # Promote the current mix
    Room.all.each do |room|
      primary_jam = room.jams.tagged_with('Mix', on: :jam_type).last
      primary_jam&.promote
    end
  end

  def down
    remove_column :jams, :promoted_at
  end
end
