get '/transaction/new' do
  erb :transaction_new
end

post '/transactions' do
  receiver = User.find_or_create_by!(email: params[:to])
  # make_coinbase_payment(params, receiver)
  # venmo_transfer_to_initializing_user
  # venmo_transaction_log = venmo_payment_from_currentuser_to_recipient(receiver)
  transaction = Transaction.new(
    amount: params[:amount].to_f*100,
    description: params[:description],
    sender_id: current_user.id,
    receiver_id: receiver.id,
    status: "complete",
    transaction_type: receiver.email,
    # venmo_json_response: venmo_transaction_log,
  )


  if transaction.save
    content_type :json
    html = erb :'_transaction_row', layout: false, locals: {transaction: transaction}
    {
      pending: transaction.pending?,
      html: html,
    }.to_json
  else
    status 500
    content_type :json
    {
      transaction: transaction.to_json(methods: [:errors]),
    }.to_json
  end
end


put '/transaction/:id' do
  transaction = Transaction.find(params[:id])
  if params[:content] == 'accept'
    transaction.status = 'completed'
  else params[:content] == 'reject'
    transaction.status = 'rejected'
  end
  transaction.save
  content_type :json
  transaction.to_json
end
