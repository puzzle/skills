class AddAuthUserIdToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :auth_user_id, :integer, foreign_key: { to_table: :people }
  end
end
