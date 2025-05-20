class DepartmentSkillsSnapshotBuilder
  # This will create snapshots of all departments with their respective skills and levels.
  # Each snapshot is an instance of DepartmentSkillSnapshot which takes a hash of skills.
  # This hash has the format:
  # { <skill_id1> => [skill_level1, skill_level2], <skill_id2> => [skill_level1, skill_level2] }
  # The count of skill_levels per skill_id is equal to the count of people that have rated that
  # skill in a given department.

  def snapshot_all_departments
    Person.where.not(department_id: nil).group_by(&:department_id).each do |department_id, people|
      department_skill_levels = PeopleSkill
                                .where(person_id: people)
                                .group_by(&:skill_id)
                                .transform_values { |value| value.pluck(:level) }

      DepartmentSkillSnapshot.create!(department_id:, department_skill_levels:)
    end
  end
end
