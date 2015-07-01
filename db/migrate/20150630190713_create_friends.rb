class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :friend_of_id
      t.string  :username
      t.string  :display_name
      t.string :venmo_account
      t.string  :avatar_url
    end
  end
end
