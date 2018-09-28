
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
      report.add_field(:title_function, person.role)

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
      report.add_field(:origin, person.origin)
      report.add_field(:language, person.language)
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

    def insert_educations(report)
      educations_list = person.educations.list.collect do |e|
        { year: formatted_year(e), title: "#{e.title}\n#{e.location}" }
      end

      report.add_table('EDUCATIONS', educations_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:education, :title)
      end
    end

    def insert_advanced_trainings(report)
      advanced_trainings_list = person.advanced_trainings.list.collect do |at|
        { year: formatted_year(at), description: at.description }
      end

      report.add_table('ADVANCED_TRAININGS', advanced_trainings_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:advanced_training, :description)
      end
    end

    def insert_activities(report)
      activities_list = person.activities.list.collect do |a|
        { year: formatted_year(a), description: "#{a.role}\n\n#{a.description}" }
      end

      report.add_table('ACTIVITIES', activities_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:activity, :description)
      end
    end

    def insert_projects(report)
      projects_list = person.projects.list.collect do |p|
        { year: formatted_year(p), project: project_description(p) }
      end

      report.add_table('PROJECTS', projects_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:project_description, :project)
      end
    end

    def project_description(project)
      str = ''
      str << "#{project.title}\n\n"
      str << "#{project.description}\n\n"
      str << "#{project.role}\n\n"
      str << project.technology.to_s
    end

    def formatted_year(obj)
      if obj.year_to.nil?
        "#{obj.year_from} - heute"
      elsif obj.year_from == obj.year_to
        obj.year_to
      else
        "#{obj.year_from} - #{obj.year_to}"
      end
    end
  end
end
