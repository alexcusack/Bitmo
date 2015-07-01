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
  receiver = User.where(username: params[:to]).first
  if receiver.nil?
    receiver = Friend.where(username: params[:to], friend_of_id: current_user.id).first
    p "{LOG} Found venmo friend"
    arguments = params
    token = session['venmo_token']
    make_venmo_payment(receiver, token, arguments)
    p "{LOG} venmo transaction processed"
    return
    if receiver.nil?
      status 400
      return "unable to find user: #{params[:to].inspect}"
    end
  end

  transaction = Transaction.new(
    amount: params[:amount],
    description: params[:description],
    sender_id: current_user.id,
    receiver_id: receiver.id,
    sender_account: "#{current_user.coinbase_account}",
    receiver_account: "#{receiver.venmo_account}",
    status: "complete",
    transaction_type: params[:transaction_type],
  )

  if params[:transaction_type] == "Charge"
    transaction.sender_id = "#{receiver.id}"
    transaction.receiver_id = "#{current_user.id}"
    transaction.status = "pending"
  end

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

