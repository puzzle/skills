module SkillSearchHelper
  def skills_for_select(all_skills, skill_ids, skill_id)
    options_for_select(
      all_skills,
      selected: skill_id,
      disabled: skill_ids.excluding(skill_id)
    )
  end

  def expert_mode_toggle(expert_mode)
    href = url_for(request.query_parameters.merge(expert_mode: expert_mode.toggle_value))
    link_to href do
      check_box_tag(:expert_mode, '1', expert_mode.active?, class: 'form-check-input me-2') +
        label_tag(:expert_mode, ti('expert_mode'), class: 'form-check-label')
    end
  end
end
