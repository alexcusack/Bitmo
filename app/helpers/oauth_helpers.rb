helpers do

  # def coinbase_oauth_client
  #   @coinbase_oauth_client ||= OAuth2::Client.new(
  #     ENV['COINBASE_CLIENT_ID'],
  #     ENV['COINBASE_CLIENT_SECRET'],
  #     site: 'https://www.coinbase.com/oauth/authorize',
  #   )
  # end


  # def coinbase_authorize_url
  #   coinbase_oauth_client.auth_code.authorize_url(:redirect_uri => ENV['COINBASE_CALLBACK_URL'])+'&scope=user+balance' #user+balance+addresses+buy+contacts+orders+sell+transactions+request+transfer+reports+send&meta[send_limit_amount]=99&meta[send_limit_currency]=USD&meta[send_limit_period]=day'
  # end


  # def request_coinbase_oauth_token(code)
  #   coinbase_oauth_client.auth_code.get_token(code, :redirect_uri => ENV['COINBASE_CALLBACK_URL'])
  # end


  def login_via_coinbase_token
    coinbase_user_info = request.env['omniauth.auth']['extra']['raw_info']
    # session['coinbase_token'] = token['omniauth.auth']['credentials'].to_hash
    # coinbase_user_info = get_coinbase_user_info
    user = User.where(coinbase_account: coinbase_user_info['id']).first_or_initialize
    user.username         ||= coinbase_user_info.username
    user.email            ||= coinbase_user_info.email
    user.coinbase_balance ||= coinbase_user_info.balance.amount
    user.avatar_url       ||= coinbase_user_info.avatar_url
    user.save or raise "unable to create user from coinbase data\n\n#{user.errors.full_messages.join("\n")}"
    session[:user_id] = user.id
    binding.pry
  end

  def coinbase_client
    @coinbase_client ||= Coinbase::Wallet::OAuthClient.new(access_token: request.env['omniauth.auth']['credentials']['token'], refresh_token: request.env['omniauth.auth']['credentials']['refresh_token'])
  end

  # def coinbase_token
  #     @coinbase_token ||= OAuth2::AccessToken.from_hash(coinbase_oauth_client, request.env['omniauth.auth']['credentials'])
  # end

  def get_coinbase_user_info(token)
    request.env['omniauth.auth']['extra']['raw_info']
  end

end
