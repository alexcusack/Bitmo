class AddVenmoTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :venmo_auth_token, :string
  end
end
