module SkillSearchHelper
  def department_select(form)
    options      = { include_blank: ti('dont_filter'), selected: params[:department] }
    html_options = { data: { dropdown_target: 'dropdown' }, class: 'w-25',
                     id: 'department-filter', onchange: 'this.form.requestSubmit()' }
    form.collection_select(:department, Department.order(:name), :id, :name, options, html_options)
  end

  def expert_mode_toggle(expert_mode)
    href     = url_for(request.query_parameters.merge(expert_mode: expert_mode.toggle_value))
    checkbox = check_box_tag(:expert_mode, '1', expert_mode.active?, class: 'form-check-input me-2')
    label    = label_tag(:expert_mode, ti('expert_mode'), class: 'form-check-label')
    link_to(href) { safe_join([checkbox, label]) }
  end

  def skill_select(form, skill_id)
    disabled_skills = @search.filter_rows.map(&:skill_id).excluding(skill_id)
    options = skills_for_select(skill_id, disabled_skills: disabled_skills)

    form.select 'skill_id[]',
                options, { prompt: true },
                data: { 'dropdown-target': 'dropdown' },
                onchange: 'this.form.requestSubmit()'
  end
end
