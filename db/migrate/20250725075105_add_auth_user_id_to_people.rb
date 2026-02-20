class AddAuthUserIdToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :auth_user_id, :integer
    add_foreign_key :people, :people, column: :auth_user_id
  end
end
