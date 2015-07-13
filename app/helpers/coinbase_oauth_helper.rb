helpers do

 def login_via_coinbase_token
    coinbase_user_info = request.env['omniauth.auth']['extra']['raw_info']
    session['coinbase_token'] = request.env['omniauth.auth']['credentials']
    user = User.where(coinbase_account: coinbase_user_info['id']).first_or_initialize
    user.username         ||= coinbase_user_info.username
    user.email            ||= coinbase_user_info.email
    user.coinbase_balance ||= coinbase_user_info.balance
    user.avatar_url       ||= coinbase_user_info.avatar_url
    user.save or raise "unable to create user from coinbase data\n\n#{user.errors.full_messages.join("\n")}"
    session[:user_id] = user.id
  end

  def coinbase_client
    @coinbase_client ||= Coinbase::Wallet::OAuthClient.new(access_token: session['coinbase_token']['token'], refresh_token: session['coinbase_token']['refresh_token'])
  end


end
