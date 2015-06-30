helpers do

 def add_venmo_account_info(response)
    user =  current_user
    user.venmo_base_acct = response['user']['id']
    user.venmo_balance = response['balance']
    user.save
 end


end