# frozen_string_literal: true

module Odt
  class PuzzleCv
    def initialize(cv)
      @cv = cv
    end

    def export
      country_suffix = @cv.send(:location).country == 'DE' ? '_de' : ''
      anonymous_suffix = @cv.send(:anon?) ? '_anon' : ''
      @cv.instance_variable_set(:@skills_by_level_list,
                                @cv.send(:skills_by_level_value, @cv.send(:skill_level_value))
      )
      include_level = @cv.send(:include_skills_by_level?) ? '_with_level' : ''
      new_report("cv_template#{country_suffix}#{anonymous_suffix}#{include_level}.odt")
    end

    def new_report(template_name)
      ODFReport::Report.new("lib/templates/#{template_name}") do |r|
        @cv.send(:insert_general_sections, r)
        @cv.send(:insert_locations, r)
        @cv.send(:insert_personalien, r)
        @cv.send(:insert_competences, r)
        @cv.send(:insert_advanced_trainings, r)
        @cv.send(:insert_educations, r)
        @cv.send(:insert_activities, r)
        @cv.send(:insert_projects, r)
      end
    end
  end
end
