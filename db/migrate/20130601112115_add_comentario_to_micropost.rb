class AddComentarioToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :comentario, :string
  end
end
