# frozen_string_literal: true

class ExpertiseTopicSkillValuesController < CrudController
  self.permitted_attrs = %i[years_of_experience number_of_projects last_use
                            skill_level comment expertise_topic_id person_id]

  private

  def fetch_entries
    raise unless params[:person_id] && params[:category_id]
    ExpertiseTopicSkillValue.list(params[:person_id], params[:category_id])
  end
end
