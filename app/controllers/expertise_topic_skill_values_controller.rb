class ExpertiseTopicSkillValuesController < CrudController
  self.permitted_attrs = %i[years_of_experience number_of_projects last_use
                            skill_level comment expertise_topic_id person_id]

  def create(options = {})
    person_id = params[:data][:relationships][:person][:data][:id]
    if person_id
      raise 'not yet implemented' if Person.find(person_id).origin_person_id
    end
    super
  end

  private

  def fetch_entries
    raise unless params[:person_id] && params[:category_id]
    ExpertiseTopicSkillValue.list(params[:person_id], params[:category_id])
  end
end
