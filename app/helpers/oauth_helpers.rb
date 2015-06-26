helpers do

  def coinbase_oauth_client
    @coinbase_oauth_client ||= OAuth2::Client.new(
      ENV['COINBASE_CLIENT_ID'],
      ENV['COINBASE_CLIENT_SECRET'],
      site: 'https://www.coinbase.com/oauth/authorize',
    )
  end

  def coinbase_authorize_url
    coinbase_oauth_client.auth_code.authorize_url(:redirect_uri => ENV['COINBASE_CALLBACK_URL'])+'&scope=user+balance'
  end

  def request_coinbase_oauth_token(code)
    coinbase_oauth_client.auth_code.get_token(code, :redirect_uri => ENV['COINBASE_CALLBACK_URL'])
  end

  def login_via_coinbase_token(token)
    session['coinbase_token'] = token.to_hash
    coinbase_user_info = get_coinbase_user_info
    user = User.where(coin_base_acct: coinbase_user_info['id']).first_or_initialize
    user.username ||= coinbase_user_info['username']
    user.email    ||= coinbase_user_info['email']
    user.coinbase_balance ||= coinbase_user_info['balance']['amount']
    user.avatar_url ||= coinbase_user_info['avatar_url']
    user.save or raise "unable to create user from coinbase data\n\n#{user.errors.full_messages.join("\n")}"
    session[:user_id] = user.id
  end

  def coinbase_token
    if token_as_hash = session['coinbase_token']
      @coinbase_token ||= OAuth2::AccessToken.from_hash(coinbase_oauth_client, token_as_hash)
    end
  end

  def get_coinbase_user_info
    res = coinbase_token.get('https://api.coinbase.com/v1/users/self')
    raise "Failed to load coinbase user info" unless res.status == 200
    JSON.parse(res.body)['user']
  end



  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

end
