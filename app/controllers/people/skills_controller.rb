class People::SkillsController < CrudController
  self.permitted_attrs = %i[person_id skill_id level intereset certificate core_competence]

  self.nested_models = %i[category]

  def fetch_entries
    raise unless params[:person_id]
    PeopleSkill.all.where(person_id: params[:person_id])
  end
end
