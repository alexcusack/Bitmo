class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :access_token
      t.string :refresh_token
      t.date   :expires_at

      t.timestamps
    end
  end
end
