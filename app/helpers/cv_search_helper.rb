# frozen_string_literal: true

module CvSearchHelper

  def found_in_skills?(result)
    result[:found_in][:attribute].include?('Skills')
  end

  def query
    params[:q].split(",").find {|keyword| result[:found_in][:keywords_in_attribute].include?(keyword)}
  end
end
