module UnifiedSkillsHelper
  def skills_for_dropdown
    options_for_select(
      Skill.all.map { |skill| [skill.title, skill.id] }.unshift([ta('please_select'), nil])
    )
  end

  def old_skill_id1
    params[:old_skill_id1]
  end

  def old_skill_id2
    params[:old_skill_id2]
  end
end
