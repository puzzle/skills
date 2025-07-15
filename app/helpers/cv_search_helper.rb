# frozen_string_literal: true

module CvSearchHelper

  def found_in_skills?(found_in)
    found_in[:attribute].include?('Skills')
  end

  def path(result, found_in)
    person_id = result[:person][:id]
    if found_in_skills?(found_in)
      person_people_skills_path(person_id, url_params(result, found_in))
    else
      person_path(person_id, url_params(result, found_in))
    end
  end

  def url_params(result, found_in)
    query = params[:q].split(',').find do |keyword|
      found_in[:keywords_in_attribute].include?(keyword)
    end
    { q: query, rating: found_in_skills?(found_in) ? 1 : nil }
  end
end
