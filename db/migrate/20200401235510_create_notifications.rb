class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :actor_id
      t.string :notify_type, null: false
      t.string :target_type
      t.integer :target_id
      t.datetime :read_at

      t.timestamps
    end
  end
end
