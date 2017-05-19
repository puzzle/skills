class DropStatus < ActiveRecord::Migration[5.0]
  def change
    if foreign_key_exists?(:people, 'fk_fvgor3lwaybcryho1rkecma08')
      remove_foreign_key :people, name: 'fk_fvgor3lwaybcryho1rkecma08'
    end
    drop_table :statuses
  end
end
