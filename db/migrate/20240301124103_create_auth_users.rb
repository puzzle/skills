class CreateAuthUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_users do |t|
      t.string :uid
      t.string :email
      t.string :name
      t.datetime :last_login
      t.boolean :is_admin, default: false, null: false
      t.timestamps
    end
    add_index :auth_users, :uid, unique: true
  end
end
