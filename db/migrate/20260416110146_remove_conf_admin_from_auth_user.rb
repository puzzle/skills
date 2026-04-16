class RemoveConfAdminFromAuthUser < ActiveRecord::Migration[8.1]
  def change
    remove_column :auth_users, :is_conf_admin
  end
end
