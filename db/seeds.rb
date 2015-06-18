require 'faker'

20.times do
  User.create(
     first_name: Faker::Name.first_name,
     last_name: Faker::Name.last_name,
     username: Faker::Internet.user_name,
     password_hash: 'banana',
     phone_number: 'banana',
     email: Faker::Internet.email,
     coin_base_acct: "12345678",
     venmo_base_acct: "123456"
    )
end


100.times do
  status = ["pending", "complete", "rejected"].sample
  sender = (1..20).to_a.sample
  receiver = sender/2
  Transaction.create(
    sender_id: sender,
    receiver_id: receiver,
    amount: Faker::Commerce.price,
    description: Faker::Company.catch_phrase,
    sender_account: Faker::Number.number(5),
    receiver_account: Faker::Number.number(5),
    status: status
    )
end
