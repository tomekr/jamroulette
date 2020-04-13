class AddNotesToJams < ActiveRecord::Migration[6.0]
  def change
    add_column :jams, :notes, :text
  end
end
