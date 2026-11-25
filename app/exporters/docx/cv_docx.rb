# frozen_string_literal: true
require 'sablon'

class CvDocx < ::Export::BaseCvExport
  def insert_general_sections(context)
    context[:client] = @customer_code
    context[:project] = @project_code
    context[:section] = @department_code
    context[:name] = person.name unless anon?
    context[:title_function] = person.roles.pluck(:name).join("\n")
    context[:header_info] = "#{person.name} - Version 1.0"
    context[:date] = Time.zone.today.strftime('%d.%m.%Y')
    context[:version] = '1.0'
    context[:comment] = 'Aktuelle Ausgabe'
  end

  def insert_locations(context)
    is_de = (location.country == 'DE')
    context = {
      show_footer_switzerland: (is_de = 'SWITZERLAND'),
      show_footer_germany: (is_de = 'GERMANY'),

    }
    context[:niederlassung] = location.adress_information
  end

  def insert_redhat_personalien(context)
    context[:title] = person.title
    context[:nationalities] = nationalities
  end

  def generate_document(context)
    personalien = build_personalien_rows(context)
    profile_img = nil
    if personalien[:image].file.present?
      profile_img = Sablon.content(:image, person.picture.path)
    end

    context = {
      personal_fields: [:table_rows], #???
      profile_picture: profile_img
    }

    template = Sablon.template('lib/templates/cv_template.docx')
    template.render_to_file('ausgabe.docx', context)
  end

  def insert_level_skills(context)
    skills_text = if @skills_by_level_list.empty?
                    "Der Entwickler hat keine Skills mit Level #{skill_level_value} oder höher."
                  else
                    "Der Entwickler hat sich selbst als #{stage_by_level} eingeschätzt."
                  end
    {
      show_skills_by_level: include_skills_by_level?,
      skills_present: skills_text,
      competence_table: @skills_by_level_list
    }

  end

  def insert_core_competences(context)
    base_core_competence = super
    #table
  end

  def insert_contributions(context)
    insert_contributions = if include_contributions?
                             super
                           end
    {
      show_open_source_contributions: insert_contributions
    }
  end

  def insert_languages(context, display_language)
    context[:languages] = personal_languages(display_language)
  end

  def insert_initials(context)
    initials = super
    context[:initials] = initials
  end

  def insert_competence_notes_string(context)
    competence_notes = super
    context[:competence] = competence_notes
  end

end
