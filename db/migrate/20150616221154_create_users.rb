class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password_hash
      t.string :email
      t.float :coinbase_balance
      t.float :venmo_balance
      # t.float :account_balance
      t.string :coinbase_account
      t.string :venmo_account
      t.string :avatar_url

      t.timestamps
    end
  end
end
