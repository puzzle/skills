module SkillSearchHelper
  def skills_for_select(skill_ids, skill_id)
    options_for_select(
      Skill.order(:title).map { |skill| [skill.title, skill.id] },
      selected: skill_id,
      disabled: skill_ids.excluding(skill_id)
    )
  end
end
