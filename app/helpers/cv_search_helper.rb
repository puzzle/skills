# frozen_string_literal: true

module CvSearchHelper

  def found_in_skills?(result)
    result[:found_in][:attribute].include?('Skills')
  end

  def path(result)
    person_id = result[:person][:id]
    if found_in_skills?(result)
      person_people_skills_path(person_id, url_params(result))
    else
      person_path(person_id, url_params(result))
    end
  end

  def url_params(result)
    query = params[:q].split(',').find do |keyword|
      result[:found_in][:keywords_in_attribute].include?(keyword)
    end
    { q: query, rating: found_in_skills?(result) ? 1 : nil }
  end
end
