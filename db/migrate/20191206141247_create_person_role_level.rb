class CreatePersonRoleLevel < ActiveRecord::Migration[6.0]
  def up
    
    create_table :person_role_levels do |t|
      t.string :level
      
      t.timestamps
    end
    
    rename_column :person_roles, :level, :level_old
    add_column :person_roles, :person_role_level_id, :integer

    PersonRole.find_each do |person_role|
      value = person_role.level_old == 'Keine' ? ' ' : person_role.level_old
      new_level = PersonRoleLevel.find_or_create_by(level: value)
      person_role.update!(person_role_level: new_level)
    end

    remove_column :person_roles, :level_old, :string

  end

  def down

    add_column :person_roles, :level_string, :string

    PersonRole.find_each do |person_role|
      level = person_role.person_role_level.level
      person_role.update!(level_string: level)
    end

    remove_column :person_roles, :person_role_level_id, :integer

    rename_column :person_roles, :level_string, :level

    drop_table :person_role_levels
  end
end
