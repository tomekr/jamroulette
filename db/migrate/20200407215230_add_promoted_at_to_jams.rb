class AddPromotedAtToJams < ActiveRecord::Migration[6.0]
  def change
    add_column :jams, :promoted_at, :datetime
  end
end
