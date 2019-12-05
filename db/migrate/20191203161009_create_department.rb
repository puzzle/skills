class CreateDepartment < ActiveRecord::Migration[6.0]
  def up
    create_table :departments do |t|
      t.string :name

      t.timestamps
    end

    rename_column :people, :department, :department_old
    add_column :people, :department_id, :integer

  Person.find_each do |person|
    value = person.department_old
    department = Department.find_or_create_by(name: value)
    person.update!(department: department)
  end

    remove_column :people, :department_old, :string

  end

  def down
    add_column :people, :department_name, :string

    Person.find_each do |person|
      name = person.department.name
      person.update!(department_name: name)
    end

    remove_column :people, :department_id, :integer
    
    rename_column :people, :department_name, :department

    drop_table :departments
  end
end
