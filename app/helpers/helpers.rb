helpers do

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def get_all_user_transactions
    payments = current_user.payments
    receipts = current_user.receipts
    return @user_transactions = payments + receipts
  end

  def chronological_sort_transactions
    @user_transactions.sort!{|a,b| b.created_at <=> a.created_at}
    return @user_transactions
  end


end
