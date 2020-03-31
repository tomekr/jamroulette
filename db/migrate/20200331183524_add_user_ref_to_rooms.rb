class AddUserRefToRooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :rooms, :user, null: true, foreign_key: true
  end
end
