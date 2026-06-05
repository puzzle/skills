class RemoveConfAdminFromAuthUser < ActiveRecord::Migration[8.1]
  def change
    remove_column :auth_users, :is_conf_admin, :boolean, default: false, null: false
  end
end