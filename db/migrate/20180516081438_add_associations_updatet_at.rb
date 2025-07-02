class AddAssociationsUpdatetAt < ActiveRecord::Migration[5.1]
  def up
  	add_column :people, :associations_updated_at, :timestamp
  	add_column :companies, :associations_updated_at, :timestamp
  end

  def down
  	remove_column :people, :associations_updated_at
  	remove_column :companies, :associations_updated_at
  end
end
