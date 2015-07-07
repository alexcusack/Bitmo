get '/transaction/new' do
  erb :transaction_new
end


post '/transactions' do

  receiver = Friend.find_or_create_by!(email: params[:to]) #TOOD: add email field to friends table
  make_coinbase_payemt(params)
  venmo_transfer_to_initializing_user
  venmo_payment_from_currentuser_to_receipant(receiver)


  transaction = Transaction.new(
    amount: params[:amount],
    description: params[:description],
    sender_id: current_user.id,
    receiver_id: receiver.id,
    sender_account: "#{current_user.coinbase_account}",
    receiver_account: "#{receiver.venmo_account}",
    status: "complete",
    transaction_type: params[:transaction_type],
    venmo_json_response: response.to_json
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