# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.references :group, null: false, foreign_key: true
      t.references :recipient, index: true, foreign_key: { to_table: :users }
      t.references :sender, index: true, foreign_key: { to_table: :users }
      t.string :invite_token, unique: true
      t.string :role
      t.datetime :expires_at, index: true

      t.timestamps
    end
  end
end
