class AddAuthUserIdToPeople < ActiveRecord::Migration[8.0]
  def change
    add_reference :people, :auth_user, type: :integer, foreign_key: { to_table: :people }
  end
end
