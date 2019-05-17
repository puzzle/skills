class People::SkillsController < CrudController
  include ExportController

  self.permitted_attrs = %i[person_id skill_id level interest certificate core_competence]

  self.nested_models = %i[category]

  def index
    format_csv? ? export : super
  end

  private

  def fetch_entries
    PeopleSkill.where(person_id: params[:person_id])
  end

  def export
    entries = PeopleSkill.where(person_id: params[:person_id])


    send_data Csv::PeopleSkills.new(entries).export,
              type: :csv,
              disposition: disposition
  end

  def disposition
    content_disposition('attachment', filename(person.name, 'skills', 'csv'))
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
