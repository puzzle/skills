class AddConfAdminToAuthUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_users, :is_conf_admin, :boolean, default: false, null: false
  end
end
