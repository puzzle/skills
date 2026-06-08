class AddAuthUserIdToPeople < ActiveRecord::Migration[8.0]
    def change
      add_reference :people,
                    :auth_user,
                    foreign_key: { to_table: :auth_users },
                    type: :integer
    end
end