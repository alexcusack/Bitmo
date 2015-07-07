helpers do

 def make_coinbase_payemt(params)
  acount = coinbase_client.primary_account
  account.send(to: 'cusackalex@me.com', amount: params[:amount], currency: params[:currency], two_factor_token: params[:auth])
 end

 def venmo_transfer_to_initializing_user
  uri = URI("https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
  return Transaction.make_venmo_payment(uri)
 end

 def venmo_payment_from_currentuser_to_receipant(receiver)
  uri = URI("https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
  return Transaction.make_venmo_payment(uri)
 end

end
