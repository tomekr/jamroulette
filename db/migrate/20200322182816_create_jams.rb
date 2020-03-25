class CreateJams < ActiveRecord::Migration[6.0]
  def change
    create_table :jams do |t|
      t.string :bpm
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
