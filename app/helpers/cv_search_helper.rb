# frozen_string_literal: true

module CvSearchHelper

  def found_in_skills?(result)
    result[:found_in][:attribute].include?('Skills')
  end
end
