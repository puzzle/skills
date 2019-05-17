class SkillsController < CrudController
  include OdtExportController

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def index
    return export if params[:format]
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  private

  def fetch_entries
    SkillsFilter.new(super, params[:category], params[:title], params[:defaultSet]).scope
  end

  def export
    odt_file = Odt::Skillset.new(fetch_entries).export
    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename('Skillset'))
  end
end
