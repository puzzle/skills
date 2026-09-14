# frozen_string_literal: true

require 'i18n_data'
module Odt
  # rubocop:disable Metrics/ClassLength
  class Cv < ::Export::BaseCvExport

    attr_accessor :person

    # rubocop:disable Metrics/AbcSize
    def insert_general_sections(report)
      report.add_field(:client, @customer_code)
      report.add_field(:project, @project_code)
      report.add_field(:section, @department_code)
      report.add_field(:name, person.name) unless anon?
      report.add_field(:title_function, person.roles.pluck(:name).join("\n"))
      report.add_field(:header_info, "#{person.name} - Version 1.0")

      report.add_field(:date, Time.zone.today.strftime('%d.%m.%Y'))
      report.add_field(:version, '1.0')
      report.add_field(:comment, 'Aktuelle Ausgabe')
    end

    def insert_locations(report)
      is_de = location.country == 'DE'
      # The add_section method is used here to display the switzerland / germany footer
      # either 1 or 0 times
      report.add_section('FOOTER_SWITZERLAND', is_de ? [] : [1]) { nil }
      report.add_section('FOOTER_GERMANY', is_de ? [1] : []) { nil }
      report.add_field(:niederlassung, location.adress_information)
    end

    def insert_redhat_personalien(report)
      report.add_field(:title, person.title)
      report.add_field(:nationalities, nationalities)
    end

    def generate_document(report)
      personalien = build_personalien_rows(report)

      report.add_table('PERSONAL_FIELDS', personalien[:table_rows], header: false) do |t|
        t.add_column(:field, :field)
        t.add_column(:value, :value)
      end
      if personalien[:image]
        report.add_image(personalien[:image].identifier, personalien[:image].path)
      end
      report.render
    end

    # rubocop:disable Metrics/MethodLength
    def insert_level_skills(report)
      report.add_section('SKILLS_BY_LEVEL', include_skills_by_level? ? [1] : []) do
        if @skills_by_level_list.empty?
          # rubocop:disable Layout/LineLength
          report.add_field(:skills_present,
                           "Der Entwickler hat keine Skills mit Level #{skill_level_value} oder höher.")
          # rubocop:enable Layout/LineLength
        else
          report.add_field(:skills_present,
                           "Der Entwickler hat sich selbst als #{stage_by_level} eingeschätzt.")
        end
        report.add_table('LEVEL_COMPETENCES', @skills_by_level_list, header: true) do |t|
          t.add_column(:category, :category)
          t.add_column(:competence, :competence)
        end
      end
    end

    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # rubocop:disable Metrics/MethodLength
    def insert_core_competences(report)
      base_core_competence = super
      report.add_table('COMPETENCES', base_core_competence, header: true) do |t|
        t.add_column(:category, :category)
        t.add_column(:competence, :competence)
      end
    end

    def insert_contributions(report)
      report.add_section('OPEN_SOURCE_CONTRIBUTIONS', include_contributions? ? [1] : []) do
        super
      end
    end

    def insert_languages(report, display_language)
      report.add_field(:languages, personal_languages(display_language))
    end

    def insert_initials(report)
      initials = super
      report.add_field(:initials, initials)
    end

    def insert_competence_notes_string(report)
      competence_notes = super
      report.add_field(:competence, competence_notes)
    end
  end

  # rubocop:enable Metrics/ClassLength
end
