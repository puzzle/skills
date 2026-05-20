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
    query = params[:q].split(',').map(&:strip).find do |keyword|
      found_in[:keywords_in_attribute].include?(keyword)
    end
    { q: query, section_id: found_in[:group],
      rating: found_in_skills?(found_in) ? 1 : nil }
  end

  def category_select(form)
    options      = { include_blank: ti('dont_filter'), selected: params[:category] }
    html_options = { data: { dropdown_target: 'dropdown' }, class: 'w-25',
                     id: 'category-filter', onchange: 'this.form.requestSubmit()' }
    form.select(:category, options_for_select(@attributes, params[:category]), options,
html_options)
  end
end
