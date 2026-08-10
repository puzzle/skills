module ProjectHelper
  def humanize_project_technologies(project)
    ([project.technology] + project.skills.map(&:title)).compact_blank.join(', ')
  end

  def project_skills_dropdown_options
    { data: { controller: 'dropdown', dropdown_multiple_value: true,
              dropdown_placeholder_text_value: ta(:please_select),
              dropdown_hide_selected_value: true,
              dropdown_clear_text_value: true,
              dropdown_add_link_value: skills_path(open_modal: true),
              dropdown_add_link_label_value: ti('add_skill') } }
  end
end
