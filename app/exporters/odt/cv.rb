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

    # rubocop:disable Metrics/MethodLength
    def export
      country_suffix = location.country == 'DE' ? '_de' : ''
      anonymous_suffix = anon? ? '_anon' : ''
      @skills_by_level_list = skills_by_level_value(skill_level_value)
      include_level = include_skills_by_level? ? '_with_level' : ''
      template_name = "cv_template#{country_suffix}#{anonymous_suffix}#{include_level}.odt"
      ODFReport::Report.new("lib/templates/#{template_name}") do |r|
        insert_general_sections(r)
        insert_locations(r)
        insert_personalien(r)
        insert_competences(r)
        insert_advanced_trainings(r)
        insert_educations(r)
        insert_activities(r)
        insert_projects(r)
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

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

    def stage_by_level
      %w(Trainee Junior Professional Senior Expert)[skill_level_value.to_i - 1]
    end

    def stage_by_given_level(level)
      %w(Trainee Junior Professional Senior Expert)[level - 1]
    end

    def format_competences_list(sort_by_level, skills, grouped_by_level_skills)
      sort_by_level ? grouped_by_level_skills.join("\r\n \r\n") : skills.pluck(:title).join(', ')
    end

    def location
      BranchAdress.find(@params[:location])
    end

    attr_accessor :person

    def insert_general_sections(report) # rubocop:disable Metrics/AbcSize
      report.add_field(:client, 'mg')
      report.add_field(:project, 'pcv')
      report.add_field(:section, 'dev1')
      report.add_field(:name, person.name) unless anon?
      # For the moment we only take the first role, will change when there are many per person
      report.add_field(:title_function, person.roles[0].try(:name))

      report.add_field(:header_info, "#{person.name} - Version 1.0")

      report.add_field(:date, Time.zone.today.strftime('%d.%m.%Y'))
      report.add_field(:version, '1.0')
      report.add_field(:comment, 'Aktuelle Ausgabe')
    end

    def insert_locations(report)
      report.add_field(:niederlassung, location.adress_information)
    end

    def insert_personalien(report) # rubocop:disable Metrics/AbcSize
      report.add_field(:title, person.title)
      unless anon?
        report.add_field(:birthdate, Date.parse(person.birthdate.to_s)
                                         .strftime('%d.%m.%Y'))
        report.add_field(:nationalities, nationalities)
        report.add_field(:email, person.email)
        report.add_image(:profile_picture, person.picture.path) if person.picture.file.present?
      end
      report.add_field(:languages, languages)
    end

    def insert_competences(report)
      insert_level_skills(report) if include_skills_by_level?
      insert_core_competences(report)
    end

    # rubocop:disable Metrics/MethodLength
    def insert_level_skills(report)
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
    # rubocop:enable Metrics/MethodLength

    def skills_by_level_value(level_value)
      level_skills_ids = skills_by_level(level_value).pluck(:skill_id)
      competences_list(level_skills_ids, true)
    end

    def competences_list(competences_ids, sort_by_level)
      Category.all_parents.map do |parent_c|
        skills = Skill.joins(:category)
                      .where(categories: { parent_id: parent_c.id }, id: competences_ids)

        # skills = skills.map {|skill| skill.people_skills.where(person_id: person.id).group_by {|ps| ps.level}}
        grouped_by_level_skills = skills.map do |skill|
          grouped_skills = skill.people_skills.where(person_id: person.id).group_by {|ps| ps.level}
          grouped_skills.keys.map { |grouped_skill| "#{stage_by_given_level(grouped_skill)}: \r\n - #{skill.title}"}
        end

        next if skills.blank?
        { category: parent_c.title, competence: format_competences_list(sort_by_level, skills, grouped_by_level_skills)}
      end.compact
    end

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
      person.people_skills.where('level >= ?', level_value)
    end

    def competence_notes_list
      if person.competence_notes.present?
        {
          category: 'Notizen',
          competence: person.competence_notes.strip
        }
      else
        []
      end
    end

    # rubocop:disable Metrics/MethodLength
    def insert_educations(report) # rubocop:disable Metrics/AbcSize
      educations_list = person.educations.list.collect do |e|
        { year_from: formatted_year(e.year_from),
          month_from: formatted_month(e.month_from),
          year_to: formatted_year(e.year_to),
          month_to: formatted_month(e.month_to),
          title: "#{e.title}\n#{e.location}" }
      end

      report.add_table('EDUCATIONS', educations_list, header: true) do |t|
        t.add_column(:month_from, :month_from)
        t.add_column(:year_from, :year_from)
        t.add_column(:month_to, :month_to)
        t.add_column(:year_to, :year_to)
        t.add_column(:education, :title)
      end
    end

    def insert_advanced_trainings(report) # rubocop:disable Metrics/AbcSize
      advanced_trainings_list = person.advanced_trainings.list.collect do |at|
        { year_from: formatted_year(at.year_from),
          month_from: formatted_month(at.month_from),
          year_to: formatted_year(at.year_to),
          month_to: formatted_month(at.month_to),
          description: at.description }
      end

      report.add_table('ADVANCED_TRAININGS', advanced_trainings_list, header: true) do |t|
        t.add_column(:month_from, :month_from)
        t.add_column(:year_from, :year_from)
        t.add_column(:month_to, :month_to)
        t.add_column(:year_to, :year_to)
        t.add_column(:advanced_training, :description)
      end
    end

    def insert_activities(report) # rubocop:disable Metrics/AbcSize
      activities_list = person.activities.list.collect do |a|
        { year_from: formatted_year(a.year_from),
          month_from: formatted_month(a.month_from),
          year_to: formatted_year(a.year_to),
          month_to: formatted_month(a.month_to),
          description: "#{a.role}\n\n#{a.description}" }
      end

      report.add_table('ACTIVITIES', activities_list, header: true) do |t|
        t.add_column(:month_from, :month_from)
        t.add_column(:year_from, :year_from)
        t.add_column(:month_to, :month_to)
        t.add_column(:year_to, :year_to)
        t.add_column(:activity, :description)
      end
    end

    def insert_projects(report) # rubocop:disable Metrics/AbcSize
      projects_list = person.projects.list.collect do |p|
        { year_from: formatted_year(p.year_from),
          month_from: formatted_month(p.month_from),
          year_to: formatted_year(p.year_to),
          month_to: formatted_month(p.month_to),
          project_title: p.title,
          project_description: p.description,
          project_role: p.role,
          project_technology: p.technology.to_s }
      end

      report.add_table('PROJECTS', projects_list, header: true) do |t|
        t.add_column(:month_from, :month_from)
        t.add_column(:year_from, :year_from)
        t.add_column(:month_to, :month_to)
        t.add_column(:year_to, :year_to)
        t.add_column(:project_title, :project_title)
        t.add_column(:project_description, :project_description)
        t.add_column(:project_role, :project_role)
        t.add_column(:project_technology, :project_technology)
      end
    end
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

    def languages
      languages = []
      person.language_skills.list.collect do |l|
        language = I18nData.languages('DE')[l.language]
        level = l.level
        languages << "#{language} (#{level})"
      end
      languages.join("\n")
    end

  end
  # rubocop:enable Metrics/ClassLength
end
