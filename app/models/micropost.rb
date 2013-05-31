class Micropost < ActiveRecord::Base
  attr_accessible :content, :titulo

  belongs_to :usuario

  validates :content, presence: true, length: { maximum: 140 }
  validates :titulo, presence: true, length: { maximum: 100 }
  validates :usuario_id, presence: true

  default_scope order: 'microposts.created_at DESC'
end
