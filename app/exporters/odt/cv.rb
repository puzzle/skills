require 'i18n_data'
module Odt
  class Cv

    def initialize(person)
      @person = person
    end

    def export
      ODFReport::Report.new('lib/templates/cv_template.odt') do |r|
        insert_general_sections(r)
        insert_personalien(r)
        insert_competences(r)
        insert_advanced_trainings(r)
        insert_languages(r)
        insert_educations(r)
        insert_activities(r)
        insert_projects(r)
      end
    end

    private

    attr_accessor :person
    # rubocop:disable Metrics/AbcSize
    def insert_general_sections(report)
      report.add_field(:client, 'mg')
      report.add_field(:project, 'pcv')
      report.add_field(:section, 'dev1')
      report.add_field(:name, person.name)
      # For the moment we only take the first role, will change when there are many per person
      report.add_field(:title_function, person.roles[0].name)

      report.add_field(:header_info, "#{person.name} - Version 1.0")

      report.add_field(:date, Time.zone.today.strftime('%d.%m.%Y'))
      report.add_field(:version, '1.0')
      report.add_field(:comment, 'Aktuelle Ausgabe')
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def insert_personalien(report)
      report.add_field(:title, person.title)
      report.add_field(:birthdate, Date.parse(person.birthdate.to_s).strftime('%d.%m.%Y'))
      report.add_field(:nationalities, nationalities)
      report.add_image(:profile_picture, person.picture.path) if person.picture.file.present?
    end
    # rubocop:enable Metrics/AbcSize

    def insert_competences(report)
      bullet = "\u2022"
      competences_string = ''
      if person.competences.present?
        person.competences.split("\n").each do |competence|
          competences_string << "#{bullet} #{competence}\n"
        end
      end
      report.add_field(:competences, competences_string)
    end

    def insert_languages(report)
      languages_list = person.language_skills.list.collect do |l|
        language = I18nData.languages('DE')[l.language]
        { language: language, level: l.level, certificate: l.certificate }
      end

      report.add_table('LANGUAGES', languages_list, header: true) do |t|
        t.add_column(:language, :language)
        t.add_column(:level, :level)
        t.add_column(:certificate, :certificate)
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_educations(report)
      educations_list = person.educations.list.collect do |e|
        { year_from: formatted_year(e.start_at),
          month_from: formatted_month(e.start_at),
          year_to: formatted_year(e.finish_at),
          month_to: formatted_month(e.finish_at),
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_advanced_trainings(report)
      advanced_trainings_list = person.advanced_trainings.list.collect do |at|
        { year_from: formatted_year(at.start_at),
          month_from: formatted_month(at.start_at),
          year_to: formatted_year(at.finish_at),
          month_to: formatted_month(at.finish_at),
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_activities(report)
      activities_list = person.activities.list.collect do |a|
        { year_from: formatted_year(a.start_at),
          month_from: formatted_month(a.start_at),
          year_to: formatted_year(a.finish_at),
          month_to: formatted_month(a.finish_at),
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def insert_projects(report)
      projects_list = person.projects.list.collect do |p|
        { year_from: formatted_year(p.start_at),
          month_from: formatted_month(p.start_at),
          year_to: formatted_year(p.finish_at),
          month_to: formatted_month(p.finish_at),
          project: project_description(p) }
      end

      report.add_table('PROJECTS', projects_list, header: true) do |t|
        t.add_column(:month_from, :month_from)
        t.add_column(:year_from, :year_from)
        t.add_column(:month_to, :month_to)
        t.add_column(:year_to, :year_to)
        t.add_column(:project_description, :project)
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def project_description(project)
      str = ''
      str << "#{project.title}\n\n"
      str << "#{project.description}\n\n"
      str << "#{project.role}\n\n"
      str << project.technology.to_s
    end

    def formatted_month(date)
      return '' unless date
      [13, 14].include?(date.day) ? '' : "#{date.month}."
    end

    def formatted_year(date)
      date ? date.year : 'heute'
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
