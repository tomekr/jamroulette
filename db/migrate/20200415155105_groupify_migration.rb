# frozen_string_literal: true

class GroupifyMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :type
      t.string :name
      t.boolean :private, default: true

      t.timestamps
    end

    create_table :group_memberships do |t|
      t.references :member, polymorphic: true, index: true, null: false
      t.references :group, polymorphic: true, index: true

      # The membership type the member belongs with
      t.string     :membership_type

      t.timestamps
    end
  end
end
