class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :usuario

  validates :content, presence: true, length: { maximum: 140 }
  validates :usuario_id, presence: true

  default_scope order: 'microposts.created_at DESC'
end
