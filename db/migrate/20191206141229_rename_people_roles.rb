class RenamePeopleRoles < ActiveRecord::Migration[6.0]
  def change
    rename_table :people_roles, :person_roles
  end
end
