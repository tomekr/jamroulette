# frozen_string_literal: true

class AddPromotedAtToJams < ActiveRecord::Migration[6.0]
  def change
    add_column :jams, :promoted_at, :datetime, index: true
  end
end
