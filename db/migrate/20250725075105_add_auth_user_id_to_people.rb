class AddAuthUserIdToPeople < ActiveRecord::Migration[8.0]
    def change
      add_reference :people,
                    :auth_user,
                    foreign_key: { to_table: :auth_users },
                    type: :integer
    end

    # def down
    #   remove_foreign_key :people, column: :auth_user_id if foreign_key_exists?(:people, column: :auth_user_id)
    #   remove_column :people, :auth_user_id if column_exists?(:people, :auth_user_id)
    # end
end