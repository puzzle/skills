class SkillsController < CrudController
  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[category]

  def index
    skills = fetch_entries

    render json: skills, each_serializer: SkillSerializer, include: '*'
  end
end
