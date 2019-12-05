require Rails.root.join('db', 'seeds', 'support', 'department_seeder')

seeder = DepartmentSeeder.new

seeder.seed_departments(Settings.departments)
