# frozen_string_literal: true

module CvSearchConcerns
  def should_search
    query.nil? || query.length < 3
  end
end
