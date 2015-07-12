helpers do

  def make_coinbase_payemt(params)
    account = coinbase_client.primary_account
    if account
      account.send(
        to: params[:to],
        amount: params[:amount],
        currency: params[:currency],
        two_factor_token: params[:auth],
        description: params[:description],
      )
    else
      halt! 'current user coinbase account not found'
    end
  rescue Coinbase::Wallet::InternalServerError
    # ignore these errors because it works...
  end

  def venmo_transfer_to_initializing_use
    # need a way to cache my own auth token and pass that access toek in
    # uri = URI("https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{current_user.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
    uri = URI(" https://sandbox-api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{current_user.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
    return Transaction.make_venmo_payment(uri)
  end

  def venmo_payment_from_currentuser_to_receipant(receiver)
    # uri = URI("https://api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount].to_f/100}")
    uri = URI("https://sandbox-api.venmo.com/v1/payments?access_token=#{session['venmo_token']['access_token']}&user_id=#{receiver.venmo_account}&note=#{params[:description].delete(' ')}&amount=#{params[:amount]}")
    binding.pry
    return Transaction.make_venmo_payment(uri)
  end

end
