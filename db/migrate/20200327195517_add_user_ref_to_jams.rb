class AddUserRefToJams < ActiveRecord::Migration[6.0]
  def change
    add_reference :jams, :user, null: true, foreign_key: true
  end
end
