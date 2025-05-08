# frozen_string_literal: true

module Odt
  class RedhatCv
    def initialize(redhat_cv)
      @cv = redhat_cv
    end

    def export
      ODFReport::Report.new('lib/templates/redhat_cv_template.odt') do |r|
        @cv.insert_initials(r)
        @cv.insert_languages(r, 'EN')
        @cv.insert_personalien(r)
        @cv.insert_general_sections(r)
        @cv.insert_advanced_trainings(r)
        @cv.insert_activities(r)
        @cv.insert_competence_notes_string(r)
      end
    end
  end
end
