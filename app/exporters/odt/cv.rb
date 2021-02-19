# frozen_string_literal: true

require 'i18n_data'
module Odt
  class Cv

    def initialize(person, params)
      @person = person
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def export
      country_suffix = location.country == 'DE' ? '_de' : ''
      anonymous_suffix = anon? ? '_anon' : ''
      template_name = "cv_template#{country_suffix}#{anonymous_suffix}.odt"
      ODFReport::Report.new('lib/templates/' + template_name) do |r|
        insert_general_sections(r)
        insert_locations(r)
        insert_personalien(r)
        insert_competences(r)
        insert_advanced_trainings(r)
        insert_languages(r)
        insert_educations(r)
        insert_activities(r)
        insert_projects(r)
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def anon?
      @params[:anon].presence == 'true'
    end

    def location
      BranchAdress.find(@params[:location])
    end

    # rubocop:disable Metrics/AbcSize
    attr_accessor :person
    def insert_general_sections(report)
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

    # rubocop:enable Metrics/AbcSize

    def insert_competences(report)
      competences_list = [core_competences_list, competence_notes_list].flatten
      report.add_table('COMPETENCES', competences_list, header: true) do |t|
        t.add_column(:category, :category)
        t.add_column(:competence, :competence)
      end
    end

    def core_competences_list
      core_competence_skill_ids = person.people_skills.where(core_competence: true).pluck(:skill_id)
      Category.all_parents.map do |parent_c|
        skills = Skill.joins(:category)
                      .where(categories: { parent_id: parent_c.id }, id: core_competence_skill_ids)
                      .pluck(:title)
        next if skills.blank?
        { category: parent_c.title, competence: skills.join(', ') }
      end.compact
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

    def insert_languages(report)
      languages_list = person.language_skills.list.collect do |l|
        language = I18nData.languages('DE')[l.language]
        { language: language, level: language_skill_level(l) }
      end

      report.add_table('LANGUAGES', languages_list, header: true) do |t|
        t.add_column(:language, :language)
        t.add_column(:level, :level)
      end
    end

    def language_skill_level(language_skill)
      language_skill.level +
        (language_skill.certificate.blank? ? '' : ' / Zertifikat: ' + language_skill.certificate)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_educations(report)
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

    def insert_advanced_trainings(report)
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

    def insert_activities(report)
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

    def insert_projects(report)
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def formatted_month(month)
      month ? "#{format '%02d', month}." : ''
    end

    def formatted_year(year)
      year ? year : 'heute'
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

  end
end
