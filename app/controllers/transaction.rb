# get '/transaction/:id' do
#   #view individual transaction details
# end


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


post '/transactions' do
  # receiver = User.where(username: params[:to]).first
  # if receiver.nil?

  original_note = params[:description]
  receiver = Friend.where(username: params[:to], friend_of_id: current_user.id).first

  params[:description] = params[:description].delete(' ')
  amount = params[:amount].to_f/100
  url = "https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.venmo_account}&note=#{params[:description]}&amount=#{amount}"
  uri = URI(url)
  response = Transaction.make_venmo_payment(uri, receiver)
  User.update_user_venmo_balance(current_user, response)

  if receiver.nil?
    status 400
    return "Unable to find user: #{params[:to].inspect} \n transaction was not completed"
  end

  transaction = Transaction.new(
    amount: params[:amount],
    description: original_note,
    sender_id: current_user.id,
    receiver_id: receiver.id,
    sender_account: "#{current_user.coinbase_account}",
    receiver_account: "#{receiver.venmo_account}",
    status: "complete",
    transaction_type: params[:transaction_type],
    venmo_json_response: response.to_json
  )

  # if params[:transaction_type] == "Charge"  ### <-- for now you can only pay people
  #   transaction.sender_id = "#{receiver.id}"
  #   transaction.receiver_id = "#{current_user.id}"
  #   transaction.status = "pending"
  # end

  if transaction.save
    # transaction.log_venmo_response(response)
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