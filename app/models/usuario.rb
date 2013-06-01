class Usuario < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation , :admin 

  #authenticates_with_sorcery!
  #validates_confirmation_of :password, message: " Ambos campos deben coincidir ", if: :password
  has_secure_password
  has_many :microposts, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, :presence => true,
  					           :length   => { :maximum => 50 }
  validates :email,    :presence => true,
     				           :format  => { :with => email_regex },
     				           :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
  					           :confirmation => true,
  					           :length => { :within => 6..40 }
  validates :password_confirmation, presence: true
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("usuario_id = ?", id)
  end
private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
