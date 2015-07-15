helpers do

  def make_coinbase_payment(params, receiver)
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
      halt 'current user coinbase account not found'
    end
    rescue Coinbase::Wallet::InternalServerError # ignore error because the payment actually processes...
#    rescue Coinbase::Wallet::ValidationError     # offer a better error message that doesn't break the thing...
  end

  def venmo_transfer_to_initializing_user
    uri = URI("https://api.venmo.com/v1/payments?access_token=#{AppVenmoAccount.venmo_token}&user_id=#{current_user.venmo_account}&note=#{params[:description].delete(' ')}&amount=#{params[:amount]}")
    return Transaction.make_venmo_payment(uri)
  end

  def venmo_payment_from_currentuser_to_recipient(receiver)
    uri = URI("https://api.venmo.com/v1/payments?access_token=#{current_user.venmo_auth_token}&email=#{receiver.email}&note=#{params[:description].delete(' ')}&amount=#{params[:amount]}")
    return Transaction.make_venmo_payment(uri)
  end

end
