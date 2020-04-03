class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :event, null: false
      t.references :target, polymorphic: true, null: false
      t.datetime :read_at

      t.timestamps
    end
  end
end
