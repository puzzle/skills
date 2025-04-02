class UnifiedSkillForm
  include ActiveModel::Model

  attr_accessor :old_skill_id1, :old_skill_id2, :new_skill

  validates :old_skill_id1, :old_skill_id2, :new_skill, presence: true
  validates :old_skill_id1, comparison: { other_than: :old_skill_id2 }
  validates :old_skill_id2, comparison: { other_than: :old_skill_id1 }
  validate :validate_skill

  def validate_skill
    skill = Skill.new(new_skill)
    return true if skill.valid?

    skill.errors.each do |error|
      errors.add(:"skill_#{error.attribute}", error.message)
    end
  end
end
