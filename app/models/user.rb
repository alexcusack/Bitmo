require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_many :payments, :foreign_key => 'sender_id', :class_name => 'Transaction'
  has_many :receipts, :foreign_key => 'receiver_id', :class_name => 'Transaction'

  # validates :first_name, :presence => true, length: { minimum: 2 }
  # validates :last_name, :presence => true, length: { minimum: 2 }
  validates :username, :uniqueness => true, length: { minimum: 2 }
  validates :email, :presence => true, :uniqueness => true
  validates :password_hash, :presence => true


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



end
