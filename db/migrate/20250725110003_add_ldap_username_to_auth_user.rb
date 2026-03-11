class AddLdapUsernameToAuthUser < ActiveRecord::Migration[8.0]
  def change
    add_column :auth_users, :ldap_username, :string
  end
end
