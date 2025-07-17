# encoding: utf-8
class DepartmentskillSnapshotSeeder
  def initialize
    @previous_skill_levels = {}
  end

  def seed_department_skill_snapshots
    Department.ids.each do |department_id|
      (rand(1..3)..rand(6..7)).each do |month|
        seed_snapshot_for_month(department_id, DateTime.new(2025, month, 1))
      end
      (rand(8..9)..rand(10..12)).each do |month|
        seed_snapshot_for_month(department_id, DateTime.new(2025, month, 1))
      end
    end
  end

  def seed_snapshot_for_month(department_id, date)
    DepartmentSkillSnapshot.seed do |snp|
      snp.department_id = department_id
      snp.department_skill_levels = seed_department_skill_levels(department_id)
      snp.created_at = date
      snp.updated_at = date
    end
  end

  def seed_department_skill_levels(department_id)
    skill_levels = {}

    Skill.all.each do |skill|
      previous = @previous_skill_levels.dig(department_id, skill.id)

      if previous.nil?
        new_values = Array.new(rand(8..15)) { rand(1..5) }
      else
        new_values = previous.dup
        indices_to_change = new_values.size.times.to_a.sample(rand(1..3))

        indices_to_change.each do |i|
          current_value = new_values[i]
          delta = [-2, -1, 1, 2].sample
          new_value = current_value + delta
          new_values[i] = new_value.clamp(1, 5)
        end
      end

      skill_levels[skill.id.to_s] = new_values
      @previous_skill_levels[department_id] ||= {}
      @previous_skill_levels[department_id][skill.id] = new_values
    end

    skill_levels
  end
end