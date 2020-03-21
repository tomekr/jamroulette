class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :title
      t.string :room_hash

      t.timestamps
    end
    add_index :rooms, :room_hash, unique: true
  end
end
