class AddRemoteKeyToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :remote_key, :integer
  end
end
