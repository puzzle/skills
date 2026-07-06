# frozen_string_literal: true

module CvSearchHelper

  def found_in_skills?(found_in)
    found_in[:attribute].include?('Skills')
  end

  def path(result, found_in)
    person_id = result[:person][:id]
    if found_in_skills?(found_in)
      person_people_skills_path(person_id, url_params(found_in))
    else
      person_path(person_id, url_params(found_in))
    end
  end

  def url_params(found_in)
    query = found_in[:value]
    { q: query, section_id: found_in[:group],
      rating: found_in_skills?(found_in) ? 1 : nil }
  end

  def category_select(form)
    options      = { selected: params[:category] }
    html_options = category_select_html_options
    form.select(:category, grouped_options_for_select(@attributes, params[:category]), options,
                html_options)
  end

  def category_select_html_options
    {
      data: {
        dropdown_target: 'dropdown',
        dropdown_multiple_value: true,
        action: 'change -> search#submitWithTimeout'
      },
      class: 'w-25',
      id: 'category-filter',
      multiple: true
    }
  end

  def sort_found_in_items(items)
    items.sort_by do |item|
      [
        item[:value].to_s.length,
        item[:value].to_s.downcase
      ]
    end
  end

  def search_skills_checkbox(search_skills)
    href     = cv_search_index_path(request.query_parameters.merge(search_skills: !search_skills))
    checkbox = check_box_tag(:search_skills, '1', search_skills, class: 'form-check-input me-2')
    label    = label_tag(:search_skills, ti('search_skills'), class: 'form-check-label')
    link_to(href, class: 'text-reset') { safe_join([checkbox, label]) }
  end
end
