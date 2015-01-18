class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  after_save :clear_password
  
  validates :userid, :presence => true, :uniqueness => true
  validates :email, :presence => true
  validates :fullname, :presence => true
  validates :password, :presence => true, :confirmation => true, :length => { :minimum => 6, :maximum => 20 }, :on => :create
  
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end
  
  def self.authenticate(user_id, password)
    name = self.where(userid: user_id).first
    
    if !name.nil? && name.encrypted_password != BCrypt::Engine.hash_secret(password, name.salt)
      name = nil
    end    
    name
  end
  
end
