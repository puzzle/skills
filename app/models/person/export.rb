module Person::Export
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

  def insert_general_sections(r)
    r.add_field(:client, 'mg')
    r.add_field(:project, 'pcv')
    r.add_field(:section, 'dev1')
    r.add_field(:name, name)
    r.add_field(:title_function, role)

    r.add_field(:header_info, "#{name} - Version 1.0")

    r.add_field(:date, Time.zone.today.strftime('%d.%m.%Y'))
    r.add_field(:version, '1.0')
    r.add_field(:comment, 'Aktuelle Ausgabe')
  end

  def insert_personalien(r)
    r.add_field(:title, title)
    r.add_field(:birthdate, Date.parse(birthdate.to_s).strftime('%d.%m.%Y'))
    r.add_field(:origin, origin)
    r.add_field(:language, language)
    r.add_image(:profile_picture, picture.path) if picture.file.present?
  end

  def insert_competences(r)
    bullet = "\u2022"
    competences_string = ''
    if competences.present?
      competences.split("\n").each do |competence|
        competences_string << "#{bullet} #{competence}\n"
      end
    end
    r.add_field(:competences, competences_string)
  end

  def insert_educations(r)
    educations_list = educations.collect do |e|
      { year: formatted_year(e), title: e.title }
    end

    r.add_table('EDUCATIONS', educations_list, header: true) do |t|
      t.add_column(:year, :year)
      t.add_column(:education, :title)
    end
  end

  def insert_advanced_trainings(r)
    advanced_trainings_list = advanced_trainings.collect do |at|
      { year: formatted_year(at), description: at.description }
    end

    r.add_table('ADVANCED_TRAININGS', advanced_trainings_list, header: true) do |t|
      t.add_column(:year, :year)
      t.add_column(:advanced_training, :description)
    end
  end

  def insert_activities(r)
    activities_list = activities.collect do |a|
      { year: formatted_year(a), description: a.description }
    end

    r.add_table('ACTIVITIES', activities_list, header: true) do |t|
      t.add_column(:year, :year)
      t.add_column(:activity, :description)
    end
  end

  def insert_projects(r)
    projects_list = projects.collect do |p|
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
    if obj.year_from == obj.year_to
      obj.year_to
    else
      "#{obj.year_from} - #{obj.year_to}"
    end
  end
end
