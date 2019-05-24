class PeopleSkillsController < CrudController
  self.permitted_attrs = %i[person_id skill_id level interest certificate core_competence]

  self.nested_models = %i[category]

  def index
    if params.keys.select{|k| %w[person_id skill_id].include?(k)}.length != 1
      return head 400
    end

    render json: fetch_entries, each_serializer: PeopleSkillSerializer, include: '*'
  end

  def fetch_entries
    base = PeopleSkill.includes(:person, skill: [
                                  :category, :parent_category,
                                  :people, people_skills: :person
                               ])
    if params.key?(:person_id)
      base.where(person_id: params[:person_id])
    else params.key?(:skill_id)
      base.where(skill_id: params[:skill_id])
    end
  end
end
