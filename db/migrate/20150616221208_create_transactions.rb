class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer  :sender_id
      t.integer  :receiver_id
      t.integer  :amount
      t.string   :description
      t.string   :sender_account
      t.string   :receiver_account
      t.string   :transaction_type #payment or charge
      t.string   :status
      t.string   :venmo_json_response

      t.timestamps
    end
  end
end
