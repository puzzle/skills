# frozen_string_literal: true

require 'i18n_data'
module Odt
  # rubocop:disable Metrics/ClassLength
  class Cv
    include ParamConverters

    def initialize(person, params)
      @person = person
      @params = params
    end

    def anon?
      true?(@params[:anon])
    end

    def include_core_competences_and_skills?
      true?(@params[:includeCS])
    end

    def include_skills_by_level?
      true?(@params[:skillsByLevel])
    end

    def skill_level_value
      @params[:levelValue]
    end

    def skill_level_names
      %w(Trainee Junior Professional Senior Expert)
    end

    def stage_by_level
      skill_level_names[skill_level_value.to_i - 1]
    end

    def stage_by_given_level(level)
      skill_level_names[level - 1]
    end

    def format_competences_list(sort_by_level, skills, grouped_by_level_skills)
      sort_by_level ? grouped_by_level_skills.join("\r\n") : skills.pluck(:title).join(', ')
    end

    def skills_by_level_string(grouped_people_skills_by_level)
      grouped_people_skills_by_level.map do |key, value|
        group_string = "Kompetenzen des Levels #{stage_by_given_level(key)}: \r\n"
        value.each do |people_skill|
          group_string << "- #{people_skill.skill.title} \r\n"
        end
        group_string
      end
    end

    def location
      BranchAdress.find(@params[:location])
    end

    attr_accessor :person

    # rubocop:disable Metrics/AbcSize
    def insert_general_sections(report)
      report.add_field(:client, 'mg')
      report.add_field(:project, 'pcv')
      report.add_field(:section, 'dev1')
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

    def insert_personalien(report)
      report.add_field(:title, person.title)
      unless anon?
        report.add_field(:birthdate, Date.parse(person.birthdate.to_s)
                                         .strftime('%d.%m.%Y'))
        report.add_field(:nationalities, nationalities)
        report.add_field(:email, person.email)
        report.add_image(:profile_picture, person.picture.path) if person.picture.file.present?
      end
    end

    def insert_competences(report)
      insert_level_skills(report)
      insert_core_competences(report)
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

    # rubocop:enable Metrics/MethodLength

    def skills_by_level_value(level_value)
      level_skills_ids = skills_by_level(level_value).pluck(:skill_id)
      competences_list(level_skills_ids, true)
    end

    # rubocop:disable Metrics/MethodLength
    def competences_list(competences_ids, sort_by_level)
      Category.all_parents.map do |parent_c|
        skills = Skill.joins(:category)
                      .where(categories: { parent_id: parent_c.id }, id: competences_ids)
        grouped_people_skills_by_level = skills.map do |skill|
          skill.people_skills.find_by(person_id: person.id)
        end.group_by(&:level)
        mapped_string = skills_by_level_string(grouped_people_skills_by_level.sort.reverse.to_h)

        next if skills.blank?

        { category: parent_c.title,
          competence: format_competences_list(sort_by_level, skills, mapped_string) }
      end.compact
    end

    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # rubocop:disable Metrics/MethodLength
    def insert_core_competences(report)
      core_competence_skill_ids = person.people_skills.where(core_competence: true).pluck(:skill_id)
      competences_list = if include_core_competences_and_skills?
                           [competences_list(core_competence_skill_ids, false),
                            competence_notes_list].flatten
                         else
                           [competence_notes_list].flatten
                         end
      report.add_table('COMPETENCES', competences_list, header: true) do |t|
        t.add_column(:category, :category)
        t.add_column(:competence, :competence)
      end
    end

    # rubocop:enable Metrics/MethodLength

    def skills_by_level(level_value)
      person.people_skills.where(level: level_value..)
    end

    def competence_notes_list
      return [] unless person.display_competence_notes_in_cv && person.competence_notes.present?

      { category: 'Notizen', competence: person.competence_notes.strip }
    end

    def add_cv_table(report, name, records, columns)
      report.add_table(name, records, header: true) do |t|
        columns.each { |key, attr| t.add_column(key, attr) }
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_educations(report)
      educations_list = person.educations.list.where(display_in_cv: true).collect do |e|
        { year_from: formatted_year(e.year_from),
          month_from: formatted_month(e.month_from),
          year_to: formatted_year(e.year_to),
          month_to: formatted_month(e.month_to),
          title: "#{e.title}\n#{e.location}" }
      end
      add_cv_table(report, 'EDUCATIONS', educations_list, {
                     month_from: :month_from,
                     year_from: :year_from,
                     month_to: :month_to,
                     year_to: :year_to,
                     education: :title
                   })
    end

    def insert_advanced_trainings(report)
      advanced_trainings_list = person.advanced_trainings.list.where(display_in_cv: true).collect do
      |at|
        { year_from: formatted_year(at.year_from),
          month_from: formatted_month(at.month_from),
          year_to: formatted_year(at.year_to),
          month_to: formatted_month(at.month_to),
          description: at.description }
      end

      add_cv_table(report, 'ADVANCED_TRAININGS', advanced_trainings_list, {
                     month_from: :month_from,
                     year_from: :year_from,
                     month_to: :month_to,
                     year_to: :year_to,
                     advanced_training: :description
                   })
    end

    def insert_activities(report)
      activities_list = person.activities.list.where(display_in_cv: true).collect do |a|
        { year_from: formatted_year(a.year_from),
          month_from: formatted_month(a.month_from),
          year_to: formatted_year(a.year_to),
          month_to: formatted_month(a.month_to),
          activity: a.role,
          description: a.description }
      end

      add_cv_table(report, 'ACTIVITIES', activities_list, {
                     month_from: :month_from,
                     year_from: :year_from,
                     month_to: :month_to,
                     year_to: :year_to,
                     activity: :activity,
                     activity_description: :description
                   })
    end

    def insert_projects(report)
      projects_list = person.projects.list.where(display_in_cv: true).collect do |p|
        { year_from: formatted_year(p.year_from),
          month_from: formatted_month(p.month_from),
          year_to: formatted_year(p.year_to),
          month_to: formatted_month(p.month_to),
          project_title: p.title,
          project_description: p.description,
          project_role: p.role,
          project_technology: p.technology.to_s }
      end

      add_cv_table(report, 'PROJECTS', projects_list, {
                     month_from: :month_from,
                     year_from: :year_from,
                     month_to: :month_to,
                     year_to: :year_to,
                     project_title: :project_title,
                     project_description: :project_description,
                     project_role: :project_role,
                     project_technology: :project_technology
                   })
    end

    def insert_contributions(report)
      contributions_list = person.contributions.list.where(display_in_cv: true).collect do |c|
        { year_from: formatted_year(c.year_from),
          month_from: formatted_month(c.month_from),
          year_to: formatted_year(c.year_to),
          month_to: formatted_month(c.month_to),
          contribution_title: c.title,
          contribution_reference: c.reference }
      end

      add_cv_table(report, 'CONTRIBUTIONS', contributions_list, {
        month_from: :month_from,
        year_from: :year_from,
        month_to: :month_to,
        year_to: :year_to,
        contribution_title: :contribution_title,
        contribution_reference: :contribution_reference
      })
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def formatted_month(month)
      month ? "#{format '%02d', month}." : ''
    end

    def formatted_year(year)
      year || 'heute'
    end

    def nationalities
      nationality = format_nationality(person.nationality)
      nationality2 = format_nationality(person.nationality2).presence
      [nationality, nationality2].
        compact.
        join(', ')
    end

    def format_nationality(country_code)
      return '' if country_code.blank?

      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s]
    end

    def insert_languages(report, display_language = 'DE')
      report.add_field(:languages, person.language_skills.list.map do |l|
        language = I18nData.languages(display_language)[l.language]
        "#{language} (#{l.level})"
      end.join("\n"))
    end

    def insert_initials(report)
      initials = person.name.rpartition(' ').then do |first_part, _, last_part|
        "#{first_part[0]}.#{last_part[0]}."
      end
      report.add_field(:initials, initials)
    end

    def insert_competence_notes_string(report)
      competence_notes = person.competence_notes.split("\n").join(', ')
      report.add_field(:competence, competence_notes)
    end
  end

  # rubocop:enable Metrics/ClassLength
end
