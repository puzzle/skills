class AddShortnameToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :shortname, :string
  end
end
