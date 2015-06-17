class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :amount
      t.string :description
      t.string :sender_account
      t.string :receiver_account
      t.string :status

      t.timestamps
    end
  end
end
