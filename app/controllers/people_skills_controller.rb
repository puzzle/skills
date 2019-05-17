class PeopleSkillsController < CrudController
  self.permitted_attrs = %i[person_id skill_id level interest certificate core_competence]

  self.nested_models = %i[category]

  def index
    render json: fetch_entries, each_serializer: PeopleSkillSerializer, include: '*'
  end

  def fetch_entries
    entries = PeopleSkill.where(person_id: params[:person_id])
    entries.presence || PeopleSkill.where(skill_id: params[:skill_id])
  end
end
