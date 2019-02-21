class AddNewAttributesToPeopleRoles < ActiveRecord::Migration[5.2]

  def change
    add_column :people_roles, :level, :string
    add_column :people_roles, :percent, :decimal, precision: 5, scale: 2
  end
end
