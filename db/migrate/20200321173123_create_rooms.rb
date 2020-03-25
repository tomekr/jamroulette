# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :title
      t.string :room_hash, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
