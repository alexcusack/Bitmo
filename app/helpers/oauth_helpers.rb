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


  def user_credential(token)
    session['user_credentials'] = {
      :access_token => token.token,
      :refresh_token => token.refresh_token,
      :expires_at => Time.now + 1.day
    }
  end


  def login_via_coinbase_token(token)
    user_credential(token)
    session['coinbase_token'] = token.to_hash
    coinbase_user_info = get_coinbase_user_info
    user = User.where(coinbase_account: coinbase_user_info['id']).first_or_initialize
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
    response = coinbase_token.get('https://api.coinbase.com/v1/users/self')
    raise "Failed to load coinbase user info" unless response.status == 200
    JSON.parse(response.body)['user']
  end

  def get_coinbase_balance
    # https://api.coinbase.com/v1/accounts/536a541fa9393bb3c7000034/balance
    response = coinbase_token.get("https://api.coinbase.com/v1/accounts/#{current_user.coin_base_acct}/balance")
    raise "Failed to load coinbase user info" unless response.status == 200
    JSON.parse(response.body)['user']
  end


  def add_venmo_account_info(response)
    user =  current_user
    user.venmo_account = response['user']['id']
    user.venmo_balance = response['balance']
    user.save
  end

  def get_friends
    url = "https://api.venmo.com/v1/users/#{current_user.venmo_account}/friends?access_token=#{session['venmo_token']}"
    response = RestClient.get url
    response_as_hash = JSON.parse(response.to_str)
    friends = response_as_hash['data']
    friends.each do |friend|
      person = Friend.where(username: friend['username']).first_or_initialize
      person.username     ||= friend['username']
      person.display_name ||= friend['display_name']
      person.venmo_id     ||= friend['id']
      person.avatar_url   ||= friend['profile_picture_url']
      person.friend_of_id ||= current_user.id
      person.save or raise "Friend was not save to database #{person.errors.full_messages.join("\n")}"
    end
  end


end
