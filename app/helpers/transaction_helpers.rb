helpers do

  def make_coinbase_payemt(params, receiver)
    account = coinbase_client.primary_account
    if account
      account.send(
        to: 'cusackalex@gmail.com',
        amount: params[:amount],
        sender_account: current_user,
        receiver_account: receiver.email,
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

  def venmo_transfer_to_initializing_user
    uri = URI("https://api.venmo.com/v1/payments?access_token=#{AppVenmoAccount.venmo_token}&user_id=#{current_user.venmo_account}&note=#{params[:description].delete(' ')}&amount=#{params[:amount]}")
    return Transaction.make_venmo_payment(uri)
  end

  def venmo_payment_from_currentuser_to_receipant(receiver)
    binding.pry
    uri = URI("https://api.venmo.com/v1/payments?access_token=#{current_user.venmo_account}&email=#{receiver.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount]}")
    return Transaction.make_venmo_payment(uri)
  end

end
