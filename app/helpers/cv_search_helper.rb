# frozen_string_literal: true

module CvSearchHelper
  def translate_found_in(result)
    I18n.t("cv_search.#{result[:found_in].split('#')[0].underscore}")
  end
end
