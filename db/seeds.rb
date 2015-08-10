require 'faker'

20.times do
  User.create(
     username: Faker::Internet.user_name,
     password_hash: 'banana',
     email: Faker::Internet.email,
     coinbase_account: "12345678",
     venmo_account: "123456"
    )
end


100.times do
  status = ["pending", "complete", "rejected"].sample
  sender = (1..20).to_a.sample
  type = ["payment", "charge"].sample
  receiver = sender/2
  Transaction.create(
    sender_id: sender,
    receiver_id: receiver,
    amount: Faker::Commerce.price,
    description: Faker::Company.catch_phrase,
    sender_account: Faker::Number.number(5),
    receiver_account: Faker::Number.number(5),
    transaction_type: type,
    status: status
    )
end
