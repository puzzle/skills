class AddNationalityToPerson < ActiveRecord::Migration[5.1]

  def change
    add_column :people, :nationality, :string
    add_column :people, :nationality2, :string
    remove_column :people, :origin
  end

end
