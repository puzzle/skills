class CreatePersonRoleLevel < ActiveRecord::Migration[6.0]
  def up

    create_table :person_role_levels do |t|
      t.string :level, null: false

      t.timestamps
    end

    PersonRole.reset_column_information

    rename_column :person_roles, :level, :level_old
    add_column :person_roles, :person_role_level_id, :integer

    PersonRole.find_each do |person_role|
      unless person_role.level_old.nil?
        value = person_role.level_old
        new_level = PersonRoleLevel.find_or_create_by(level: value)
        person_role.update!(person_role_level: new_level)
      end
    end

    remove_column :person_roles, :level_old, :string

  end

  def down

    add_column :person_roles, :level_string, :string

    PersonRole.reset_column_information
    
    PersonRole.find_each do |person_role|
      unless person_role.person_role_level.nil?
        level = person_role.person_role_level.level
        person_role.update!(level_string: level)
      end
    end

    remove_column :person_roles, :person_role_level_id, :integer

    rename_column :person_roles, :level_string, :level

    drop_table :person_role_levels
  end
end
