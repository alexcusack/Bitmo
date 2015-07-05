get '/transaction/new' do
  erb :transaction_new
end


post '/transactions' do
  binding.pry

  # receiver = Friend.where(username: params[:to], friend_of_id: current_user.id).first
  # if receiver.nil?
  #   status 400
  #   return "Unable to find user: #{params[:to].inspect} \n transaction was not completed"
  # end

  # uri = URI("https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.venmo_account}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
  # venmo_response = Transaction.make_venmo_payment(uri)
  # User.update_user_venmo_balance(current_user, venmo_response)

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