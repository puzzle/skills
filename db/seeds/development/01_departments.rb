require Rails.root.join('db', 'seeds', 'support', 'department_seeder')

seeder = DepartmentSeeder.new

departments =  ["/dev/one",
                "/dev/two",
                "/dev/tre",
                "/dev/ruby",
                "/mid",
                "/ux",
                "/zh",
                "/sys",
                "/bs",
                "Funktionsbereiche"]

seeder.seed_departments(departments)
