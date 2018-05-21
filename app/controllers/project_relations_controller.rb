class ProjectRelationsController < CrudController

  def create(options = {})
    build_entry
    if entry.save
      render_entry({ status: :created }
                   .merge(options[:render_options] || {}))
    else
      render_errors
    end
  end

  def fetch_entries
    model_class.where(project_id: params['project_id'])
  end

  private
  
  def project_id
    params['data']['relationships']['project']['data']['id']
  end

end
