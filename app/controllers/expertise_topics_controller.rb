class ExpertiseTopicsController < CrudController
  self.permitted_attrs = %i[name user_topic expertise_category_id]

  self.nested_models = %i[expertise_topic_skill_values]

  def fetch_entries
    raise unless params[:category_id]
    ExpertiseTopic.list(params[:category_id])
  end
end
