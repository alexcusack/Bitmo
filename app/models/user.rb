require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_many :payments, :foreign_key => 'sender_id', :class_name => 'Transaction'
  has_many :receipts, :foreign_key => 'receiver_id', :class_name => 'Transaction'

  validates :email, :presence => true


  def self.authenticate(username, entered_password)
    user = User.where(username: username).first
    if user && user.password == entered_password
      return user
    else
      return nil
    end
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.add_venmo_account_info(response, current_user)
    user = current_user
    user.venmo_auth_token = response['access_token']
    user.venmo_balance    = response['balance']
    user.venmo_account    = response['user']['id']
    user.save
  end

  def self.update_user_venmo_balance(user, response)
    user.venmo_balance = response['data']['balance'].to_f
  end

end
