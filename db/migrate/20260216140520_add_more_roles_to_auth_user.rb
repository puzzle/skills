class AddMoreRolesToAuthUser < ActiveRecord::Migration[8.1]
  def change
    add_column :auth_users, :is_editor, :boolean, default: false, null: false
  end
end
