require 'csv'

module Csv
  class PeopleSkills

    def initialize(people_skills)
      @people_skills = people_skills
    end

    def export
      entries = fetch_entries

      CSV.generate(headers: true) do |csv|
        csv << %w(Skill Kategorie Subkategorie Interesse Niveau Zertifikat Kernkompetenz)
        entries.each { |entry| csv << entry }
      end
    end

    private

    attr_reader :people_skills

    def export_attributes
      'skills.title, parents.title, categories.title, people_skills.interest,
       people_skills.level, people_skills.certificate, people_skills.core_competence'
    end

    def fetch_entries
      @entries ||= people_skills.joins(skill: :category)
                              .joins('INNER JOIN categories AS parents
                                      ON parents.id=categories.parent_id')
                              .pluck(Arel.sql(export_attributes))
    end

  end
end
