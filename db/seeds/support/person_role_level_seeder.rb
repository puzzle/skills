class PersonRoleLevelSeeder
  def seed_person_role_levels(levels)
    levels.each do |level|
      PersonRoleLevel.seed do |lev|
        lev.level = level
      end
    end
  end
end
