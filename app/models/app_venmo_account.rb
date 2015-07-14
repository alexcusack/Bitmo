module AppVenmoAccount

  SIGN_IN_URL = "https://api.venmo.com/v1/oauth/authorize?client_id=#{ENV['VENMO_CLIENT_ID']}&scope=make_payments%20access_profile%20access_friends%20access_email%20access_phone%20access_balance&response_type=code"

  def self.venmo_token

    owner = Owner.first

    if owner && owner.access_token
      return @venmo_token = AppVenmoAccount.refresh_token if owner.expires_at < Time.now
      return @venmo_token = owner.access_token
    end


    return @venmo_token if !@venmo_token.nil?

    response = HTTParty.get(SIGN_IN_URL)
    raise "failed to refresh app venmo oauth token" if response.code != 200
    form = Nokogiri(response).css('form').first

    post_body = {
      csrftoken2: form.css('[name=csrftoken2]').first[:value],
      auth_request: form.css('[name=auth_request]').first[:value],
      web_redirect_url: form.css('[name=web_redirect_url]').first[:value],
      username: ENV['APP_VENMO_USERNAME'],
      password: ENV['APP_VENMO_PASSWORD'],
      grant: 1,
    }

    response = HTTParty.post('https://api.venmo.com/v1/oauth/authorize',
      body: post_body,
      follow_redirects: false,
    )

    code = response.headers['location'].split('code=')[1]

    token_request = {
      "client_id"=>ENV['VENMO_CLIENT_ID'],
      "client_secret"=>ENV['VENMO_CLIENT_SECRET'],
      "code"=> code
      }

    get_token = RestClient.post("https://api.venmo.com/v1/oauth/access_token", token_request)

    token = JSON.parse(get_token)
    access_token   = token['access_token']
    refresh_token  = token['refresh_token']


    Owner.create!(access_token: access_token, refresh_token: refresh_token, expires_at: Time.now + 60.days)
    @venmo_token = Owner.first.access_token

  end


  def self.refresh_token
    refresh_token = Owner.first.refresh_token

    refresh_request = {
      "client_id"=>ENV['VENMO_CLIENT_ID'],
      "client_secret"=>ENV['VENMO_CLIENT_SECRET'],
      "refresh_token"=> refresh_token
    }

    new_token = RestClient.post("https://api.venmo.com/v1/oauth/access_token", refresh_request)
    token = JSON.parse(get_token)

    access_token   = token['access_token']
    refresh_token  = token['refresh_token']

    Owner.first.update_attributes(access_token: access_token, refresh_token: refresh_token, expires_at: Time.now + 60.days)

    return Owner.first.access_token
  end

end
