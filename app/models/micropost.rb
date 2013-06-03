class Micropost < ActiveRecord::Base
  attr_accessible :content, :titulo , :comentario

  belongs_to :usuario

  url_regex = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?$/

  validates :content, 		:presence => true, 
  							:length => { maximum: 140 },
  							:format  => { :with => url_regex }
  validates :titulo, 		:presence => true, 
  							:length => { maximum: 100 }  						    
  validates :comentario, length: { maximum: 140 }
  validates :usuario_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :usuario_id"
    where("usuario_id IN (#{followed_user_ids}) OR usuario_id = :usuario_id", 
          usuario_id: user.id)
  end
end

