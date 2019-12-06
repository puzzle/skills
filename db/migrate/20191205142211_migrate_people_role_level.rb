class MigratePeopleRoleLevel < ActiveRecord::Migration[6.0]
  def up
    create_table :people_role_levels do |t|
      t.string :level

      t.timestamps
    end

    rename_column :people_roles, :level, :level_old
    add_column :people_roles, :people_role_level_id, :integer

    PeopleRole.find_each do |people_role|
      value = people_role.level_old
      binding.pry
      new_level = PeopleRoleLevel.find_or_create_by(level: value)
      people_role.update!(people_role_level: new_level)
    end

    remove_column :people_roles, :level_old, :string

  end

  def down
    add_column :people_roles, :level_string, :string

    PeopleRole.find_each do |people_role|
      level = people_role.level.level
      person.update!(level_string: level)
    end

    remove_column :people_roles, :level_id, :integer

    rename_column :people_roles, :level_string, :level

    drop_table :people_role_levels
  end
end
