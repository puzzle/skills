# frozen_string_literal: true

module Odt
  class RedhatCv
    def initialize(redhat_cv)
      @cv = redhat_cv
    end

    def export
      ODFReport::Report.new('lib/templates/redhat_cv_template.odt') do |r|
        @cv.send(:insert_initials, r)
        @cv.send(:insert_personalien, r)
        @cv.send(:insert_general_sections, r)
        @cv.send(:insert_advanced_trainings, r)
        @cv.send(:insert_projects, r)
        @cv.send(:insert_competence_notes_string, r)
      end
    end
  end
end
