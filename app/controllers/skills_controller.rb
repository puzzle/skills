class SkillsController < CrudController
  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def index
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  private

  def fetch_entries
    apply_filters(super)
  end

  def apply_filters(entries)
    case params[:defaultSet]
    when 'true'
      entries = entries.where(default_set: true)
    when 'new'
      entries = entries.where(default_set: nil)
    end
    if params[:category].present?
      entries = entries.joins(:category).where(categories: { parent_id: params[:category] })
    end
    entries
  end
end
