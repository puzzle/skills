class AddIsAdminToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :is_admin, :boolean, default: false, null: false
  end
end
