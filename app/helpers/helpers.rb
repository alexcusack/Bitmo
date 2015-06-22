helpers do

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
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



end
