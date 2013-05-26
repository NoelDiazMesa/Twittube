class AddIndexToMicropost < ActiveRecord::Migration
  def change
  	add_index :microposts, [:usuario_id, :created_at]
  end
end
