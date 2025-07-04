class AddAssociationsUpdatetAt < ActiveRecord::Migration[5.1]
  def up
  	add_column :people, :associations_updatet_at, :timestamp
  	add_column :companies, :associations_updatet_at, :timestamp
  end

  def down
  	remove_column :people, :associations_updatet_at
  	remove_column :companies, :associations_updatet_at
  end
end
