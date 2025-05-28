# encoding: utf-8
class DepartmentskillSnapshotSeeder

  def seed_department_skill_snapshots
    Department.ids.each do |department_id|
      (1..12).each do |month|
        seed_snapshot_for_month(department_id, DateTime.new(2025, month, 1))
      end
    end
  end

  def seed_snapshot_for_month(department_id, date)
    DepartmentSkillSnapshot.seed do |snp|
      snp.department_id = department_id
      snp.department_skill_levels = seed_department_skill_levels
      snp.created_at = date
      snp.updated_at = date
    end
  end

  def seed_department_skill_levels
    skill_levels = {}

    Skill.all.each do |skill|
      skill_levels[skill.id.to_s] = Array.new(rand(5..10)) { rand(1..5) }
    end

    skill_levels
  end

end