class User < ActiveRecord::Base
  validates :userid, :presence => true, :uniqueness => true
  validates :email, :presence => true
  validates :fullname, :presence => true
  validates :password, :presence => true
  
  def self.authenticate(user_id, password)
    name = self.where(userid: user_id).first
    if (name)
      if name.password != password
        name = nil
      end
    end
    name
  end
  
end
