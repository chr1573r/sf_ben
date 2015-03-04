class User < ActiveRecord::Base

  has_one :session

  validates :name, length: { in: 4..25, message: "must be between 4 and 25 characters" }, if: :name_entered

  # TODO: Get better regex for email validation
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true

  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }, on: :create


  def is_owner?(requester)
    self === requester
  end

  # Returns true if an e-mail adress was entered 
  def email_entered
    !email.nil?  
  end

  def password_entered
    !password.nil?
  end

  def name_entered
    !name.nil?
  end

end
