class PersonRelationsController < CrudController
  def person_id
    params = instance_variable_get(:@_params)
    params.nil? ? nil : params['data']['relationships']['person']['data']['id']
  end

  def create(options = {})
    build_entry
    if entry.save
      render_entry({ status: :created}
                   .merge(options[:render_options] || {}))
    else
      render_errors
    end
  end

end
