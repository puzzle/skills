class DepartmentSeeder
  def seed_departments(departments)
    departments.each do |department|
      Department.seed do |dep|
        dep.name = department
      end
    end
  end
end
