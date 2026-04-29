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

  def merge_department_skills_to_new_department(old_department_ids:, new_department_id:)
    grouped_snapshots(old_department_ids).each do |month, snapshots|
      create_merged_snapshot(
        month: month,
        snapshots: snapshots,
        new_department_id: new_department_id
      )
    end
  end

  private

  def grouped_snapshots(old_department_ids)
    DepartmentSkillSnapshot
      .where(department_id: old_department_ids)
      .group_by { |snapshot| [snapshot.created_at.year, snapshot.created_at.month] }
  end

  def create_merged_snapshot(month:, snapshots:, new_department_id:)
    DepartmentSkillSnapshot.create!(
      department_id: new_department_id,
      department_skill_levels: merged_skill_levels(snapshots),
      created_at: Date.new(month[0], month[1], 1)
    )
  end

  def merged_skill_levels(snapshots)
    snapshots.each_with_object({}) do |snapshot, result|
      snapshot.department_skill_levels.each do |skill_id, levels|
        skill_id = skill_id.to_i
        result[skill_id] ||= []
        result[skill_id].concat(levels)
      end
    end
  end
end
