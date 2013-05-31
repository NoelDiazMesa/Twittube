class AddTituloToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :titulo, :string
  end
end
