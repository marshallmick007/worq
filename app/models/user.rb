class User < ActiveRecord::Base
  #http://asciicasts.com/episodes/250-authentication-from-scratch
  
  attr_accessible :username, :email, :password, :password_confirmation

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  has_many :categories

  def self.authenticate(login, password)
    user = find_by_username(login)
    if !user
      user = find_by_email(login)
    end

    if user && BCrypt::Password.new(user.password_hash) == password
      user
    else
      nil
    end
      
  end

  def encrypt_password
    if password.present?
      #self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Password.create( password )
    end
  end
end
