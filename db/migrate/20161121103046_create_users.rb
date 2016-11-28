class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :ldap_uid
      t.string :api_token
      t.integer :failed_login_attempts, default: 0
      t.datetime :last_failed_login_attempt_at

      t.timestamps
    end
  end
end
