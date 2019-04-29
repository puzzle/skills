class People::SkillsController < CrudController
  self.permitted_attrs = %i[person_id skill_id level interest certificate core_competence]

  self.nested_models = %i[category]

  def fetch_entries
    PeopleSkill.where(person_id: params[:person_id])
  end
end
