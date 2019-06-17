require 'csv'

module Csv
  class Skillset

    def initialize(skills)
      @skills = skills
    end

    def export
      CSV.generate(headers: true) do |csv|
        csv << %w(Skill Radar Portfolio Kategorie Subkategorie Default-Set Members)
        entries.each { |entry| csv << entry }
      end
    end

    private

    attr_reader :skills

    def export_attributes
      'skills.title, skills.radar, skills.portfolio, parents.title,
       categories.title, skills.default_set, count(people)'
    end

    def entries
      @entries ||= skills.joins(:category, :people)
                         .joins('INNER JOIN categories AS parents
                                 ON parents.id=categories.parent_id')
                         .group(:'skills.id', :'parents.id', :'categories.id')
                         .pluck(Arel.sql(export_attributes))
    end
  end
end
