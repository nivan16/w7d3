#FIGVAPER
class User < ApplicationRecord
  after_initialize :ensure_session_token
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: {minumum: 6, allow_nil: true}

  attr_reader :password

  def self.find_by_credentials(username, password)
    #find a user by username, and encrypted password
    #not sure if @ 
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      return user
    else
      return nil
    end
  end

  def is_password?(password)
    password_object = BCrypt::Password.new(self.password_digest)
    password_object.is_password?(password)    
  end

  def generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password) 
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    session[:session_token] = nil
    @current_user = nil
  end
end