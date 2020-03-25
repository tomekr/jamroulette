class CreateInviteCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :invite_codes do |t|
      t.string :code

      t.timestamps
    end
  end
end
