class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :usuarios, :admin, :boolean, default: false
  end
end
