helpers do

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

end
