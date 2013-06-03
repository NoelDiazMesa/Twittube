class Usuario < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation , :admin 
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

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
    Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
