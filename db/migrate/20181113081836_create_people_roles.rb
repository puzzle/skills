class CreatePeopleRoles < ActiveRecord::Migration[5.2]

  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    create_table :people_roles do |t|
      t.belongs_to :person, index: true
      t.belongs_to :role, index: true
    end

    remove_column :people, :role
  end

end
