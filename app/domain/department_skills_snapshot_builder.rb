class DepartmentSkillsSnapshotBuilder
  def snapshot_all_departments
    Person.all.group_by(&:department_id).each do |department_id, people|
      department_skills = PeopleSkill
                          .where(person_id: people)
                          .group_by(&:skill_id)
                          .transform_values do |value|
        value.pluck(:level)
      end

      DepartmentSkillSnapshot.create!(department_id:, skills: department_skills)
    end
  end
end
