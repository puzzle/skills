class AddNewAttributesToPerson < ActiveRecord::Migration[5.2]

  def change
    add_column :people, :email, :string
    add_column :people, :department, :string
  end
end
