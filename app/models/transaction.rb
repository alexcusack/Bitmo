class Transaction < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

end
