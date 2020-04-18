# frozen_string_literal: true

class GroupsMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :type
      t.string :name
      t.boolean :visible, default: false

      t.timestamps
    end

    create_table :group_memberships do |t|
      t.belongs_to :user
      t.belongs_to :group

      # The membership type the member belongs with
      t.string     :membership_type

      t.timestamps
    end
  end
end
