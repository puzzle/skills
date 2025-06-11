# frozen_string_literal: true

module Odt
  class PuzzleCv
    def initialize(puzzle_cv)
      @cv = puzzle_cv
    end

    def export
      country_suffix = @cv.send(:location).country == 'DE' ? '_de' : ''
      anonymous_suffix = @cv.send(:anon?) ? '_anon' : ''
      @cv.instance_variable_set(:@skills_by_level_list,
                                @cv.send(:skills_by_level_value, @cv.send(:skill_level_value)))
      new_report("cv_template#{country_suffix}#{anonymous_suffix}.odt")
    end

    # rubocop:disable Metrics/MethodLength
    def new_report(template_name)
      ODFReport::Report.new("lib/templates/#{template_name}") do |r|
        @cv.insert_general_sections(r)
        @cv.insert_languages(r)
        @cv.insert_locations(r)
        @cv.insert_personalien(r)
        @cv.insert_competences(r)
        @cv.insert_advanced_trainings(r)
        @cv.insert_educations(r)
        @cv.insert_activities(r)
        @cv.insert_projects(r)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
