helpers do

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end


  def logged_in?
    !current_user.nil?
  end

  def get_all_user_transactions
    payments = current_user.payments.where.not(status:'pending')
    receipts = current_user.receipts.where.not(status:'pending')
    return @user_transactions = payments + receipts
  end

  def chronological_sort_transactions
    @user_transactions.sort!{|a,b| b.created_at <=> a.created_at}
    return @user_transactions
  end

  def get_pending_transaction
    payments = current_user.payments.where(status: 'pending')
    receipts = current_user.receipts.where(status: 'pending').where.not(transaction_type: 'Charge')
    @user_pending_transactions = payments + receipts
    @user_pending_transactions.sort!{|a,b| b.created_at <=> a.created_at}
  end

  def view_profile_transactions
    payments = @user.payments.where.not(status:'pending')
    receipts = @user.receipts.where.not(status:'pending')
    @user_transactions = payments + receipts
    @user_transactions.sort!{|a,b| b.created_at <=> a.created_at}
    @user_pending_transactions = []
  end


  def get_friends(url)
    response = RestClient.get url
    response_as_hash = JSON.parse(response.to_str)
    latest_set = response_as_hash['data']
    @friends << response_as_hash['data']
    next_call = "#{response_as_hash['pagination']['next']}&access_token=#{session['venmo_token']['access_token']}"
    get_friends(next_call) unless response_as_hash['pagination']['next'].nil?
    return @friends
  end

  def add_venmo_friends
    @friends = []
    url = "https://api.venmo.com/v1/users/#{current_user.venmo_account}/friends?access_token=#{session['venmo_token']['access_token']}"
    get_friends(url)

    @friends.flatten!

    @friends.each do |friend|
      person = User.where(username: friend['username']).first_or_initialize
      person.username      ||= friend['username'].downcase
      person.venmo_account ||= friend['id']
      person.avatar_url    ||= friend['profile_picture_url']
      person.save or raise "Friend was not save to database #{person.errors.full_messages.join("\n")}"
    end
  end

end
