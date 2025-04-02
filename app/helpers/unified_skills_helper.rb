module UnifiedSkillsHelper
  def old_skill1_select_options
    options_for_select(skills_for_dropdown, selected: old_skill_id1, disabled: old_skill_id2)
  end

  def old_skill2_select_options
    options_for_select(skills_for_dropdown, selected: old_skill_id2, disabled: old_skill_id1)
  end

  def old_skill_id1
    params[:old_skill_id1]
  end

  def old_skill_id2
    params[:old_skill_id2]
  end

  private

  def skills_for_dropdown
    Skill.all.map { |skill| [skill.title, skill.id] }.unshift([ta('please_select'), nil])
  end
end
