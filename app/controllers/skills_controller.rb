class SkillsController < CrudController
  include ExportController

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def index
    return export if params[:format]
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  def unrated_by_person
    if params[:person_id].present?
      entries = Skill.default_set.where
                     .not(id: PeopleSkill.where(person_id: params[:person_id]).pluck(:skill_id))
    else
      entries = Skill.list 
    end
    render json: entries, each_serializer: SkillMinimalSerializer, include: '*'
  end

  private

  def fetch_entries
    if params[:format]
      entries = Skill.includes(:people, :parent_category, category: :parent).list
    else
      entries = Skill.includes(:people, parent_category: [:children, :parent],
                               category: [:children, :parent]).list
    end
    SkillsFilter.new(entries, params[:category], params[:title], params[:defaultSet]).scope
  end

  def export
    odt_file = Odt::Skillset.new(fetch_entries).export
    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename('Skillset'))
  end
end
