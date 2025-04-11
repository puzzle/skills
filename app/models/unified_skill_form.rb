class UnifiedSkillForm
  include ActiveModel::Model

  attr_accessor :old_skill_id1, :old_skill_id2, :new_skill, :checked_conflicts, :conflicts

  validates :old_skill_id1, :old_skill_id2, :new_skill, presence: true
  validates :old_skill_id1, comparison: { other_than: :old_skill_id2 }, if: :skill_ids_present?
  validate :validate_skill

  def initialize(attributes = nil)
    super
    self.checked_conflicts = false
  end

  def check_conflicts
    self.conflicts = Person.joins(:people_skills)
                           .where(people_skills: { skill_id: [old_skill_id1, old_skill_id2] })
                           .group('people.id')
                           .having('COUNT(people_skills.skill_id) = 2')
                           .pluck(:name)
  end

  private

  def skill_ids_present?
    old_skill_id1.present? && old_skill_id2.present?
  end

  def validate_skill
    skill = Skill.new(new_skill)
    return true if skill.valid?

    skill.errors.each do |error|
      errors.add(error.attribute.to_sym, error.message)
    end
  end
end
