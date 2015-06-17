class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :phone_number
      t.string :email
      t.string :coin_base_acct
      t.string :venmo_base_acct

      t.timestamps
    end
  end
end
