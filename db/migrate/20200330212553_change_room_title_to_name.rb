class ChangeRoomTitleToName < ActiveRecord::Migration[6.0]
  def change
    rename_column :rooms, :title, :name
  end
end
