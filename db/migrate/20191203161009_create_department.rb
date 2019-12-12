class CreateDepartment < ActiveRecord::Migration[6.0]
  def up
    create_table :departments do |t|
      t.string :name, null: false

      t.timestamps
    end

    rename_column :people, :department, :department_old
    add_column :people, :department_id, :integer

    Person.reset_column_information

    Person.find_each do |person|
      if person.department_old.present?
        value = person.department_old
        department = Department.find_or_create_by(name: value)
        person.update!(department: department)
      end
    end

    remove_column :people, :department_old, :string
    Person.reset_column_information
  end

  def down

    add_column :people, :department_name, :string

    Person.reset_column_information

    Person.find_each do |person|
      if person.department.present?
        name = person.department.name
        person.update!(department_name: name)
      end
    end

    remove_column :people, :department_id, :integer
    rename_column :people, :department_name, :department

    drop_table :departments
    Person.reset_column_information
  end
end
