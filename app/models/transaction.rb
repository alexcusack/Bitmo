class Transaction < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :sender_id, :presence => true
  validates :receiver_id, :presence => true
  validates :description, :presence => true
  validates :transaction_type, :presence => true
  validates :status, :presence => true
  validates :amount, :presence => true

  def pending?
    status == 'pending'
  end


  def self.make_venmo_payment(uri, receiver)
    response = HTTParty.post(uri)
    return response
  end


end
