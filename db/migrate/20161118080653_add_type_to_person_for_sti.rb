class AddTypeToPersonForSti < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :type, :string
  end
end
