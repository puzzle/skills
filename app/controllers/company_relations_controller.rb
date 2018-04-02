class CompanyRelationsController < CrudController
  def company_id
    params['data']['relationships']['company']['data']['id']
  end

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
    model_class.where(company_id: params['company_id'])
  end

end
