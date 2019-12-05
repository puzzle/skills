class DepartmentSeeder
  def seed_departments(departments)
    departments.each_with_index do |department|
      Department.seed() do |dep|
        dep.name = department
      end
    end
  end
end
