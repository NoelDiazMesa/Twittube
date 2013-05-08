require 'digest'
require 'bcrypt'
class Usuario < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :username, :email, :password, :password_confirmation, :password_digest

  #authenticates_with_sorcery!
  #validates_confirmation_of :password, message: " Ambos campos deben coincidir ", if: :password
  has_secure_password
  has_many :microposts, dependent: :destroy

  before_save { |user| user.email = email.downcase }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, :presence => true,
  					           :length   => { :maximum => 50 }
  validates :email,    :presence => true,
     				           :format  => { :with => email_regex },
     				           :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
  					           :confirmation => true,
  					           :length => { :within => 6..40 }

  before_save :crypted_password

  def has_password?(submitted_password)
    crypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.crypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
