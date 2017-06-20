# encoding: utf-8
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

    def insert_general_sections(r)
      r.add_field(:client, 'mg')
      r.add_field(:project, 'pcv')
      r.add_field(:section, 'dev1')
      r.add_field(:name, person.name)
      r.add_field(:title_function, person.role)

      r.add_field(:header_info, "#{person.name} - Version 1.0")

      r.add_field(:date, Time.zone.today.strftime('%d.%m.%Y'))
      r.add_field(:version, '1.0')
      r.add_field(:comment, 'Aktuelle Ausgabe')
    end

    def insert_personalien(r)
      r.add_field(:title, person.title)
      r.add_field(:birthdate, Date.parse(person.birthdate.to_s).strftime('%d.%m.%Y'))
      r.add_field(:origin, person.origin)
      r.add_field(:language, person.language)
      r.add_image(:profile_picture, person.picture.path) if person.picture.file.present?
    end

    def insert_competences(r)
      bullet = "\u2022"
      competences_string = ''
      if person.competences.present?
        person.competences.split("\n").each do |competence|
          competences_string << "#{bullet} #{competence}\n"
        end
      end
      r.add_field(:competences, competences_string)
    end

    def insert_educations(r)
      educations_list = person.educations.list.collect do |e|
        { year: formatted_year(e), title: "#{e.title}\n#{e.location}" }
      end

      r.add_table('EDUCATIONS', educations_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:education, :title)
      end
    end

    def insert_advanced_trainings(r)
      advanced_trainings_list = person.advanced_trainings.list.collect do |at|
        { year: formatted_year(at), description: at.description }
      end

      r.add_table('ADVANCED_TRAININGS', advanced_trainings_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:advanced_training, :description)
      end
    end

    def insert_activities(r)
      activities_list = person.activities.list.collect do |a|
        { year: formatted_year(a), description: "#{a.role}\n\n#{a.description}" }
      end

      r.add_table('ACTIVITIES', activities_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:activity, :description)
      end
    end

    def insert_projects(r)
      projects_list = person.projects.list.collect do |p|
        { year: formatted_year(p), project: project_description(p) }
      end

      r.add_table('PROJECTS', projects_list, header: true) do |t|
        t.add_column(:year, :year)
        t.add_column(:project_description, :project)
      end
    end

    def project_description(p)
      str = ''
      str << "#{p.title}\n\n"
      str << "#{p.description}\n\n"
      str << "#{p.role}\n\n"
      str << p.technology.to_s
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
