class User < ActiveRecord::Base
  has_secure_password
  ROLES = %w[admin region observer auth guest]
  def role?(base_role)
    ROLES.index(base_role.to_s) >= ROLES.index(role)
  end
  
  has_many :protocols
  has_many :pictures
  has_many :folders
  belongs_to :commission

  validates :name, :presence => true
  validates :commission, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 6, :maximum => 254},
                    :uniqueness => {:message => "Почтовый адрес уже используется", :case_sensitive => false},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
#  validates :password, :confirmation => true
#  validates_presence_of :password - вселенское зло
  validates_confirmation_of :password, :message => "Пароли должны совпадать!"


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #-devise :database_authenticatable, :registerable,
  #-       :recoverable, :rememberable, :trackable, :validatable

  def name
    read_attribute(:name) || "Аноним"
  end

  def send_password_reset
    begin
      self.password_reset_token = SecureRandom.base64
    end while User.exists?(:password_reset_token => password_reset_token)
    self.password_reset_sent_at = Time.now
    save!
    UserMailer.password_reset(self).deliver
  end
end
