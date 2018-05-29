class PersonRelationsController < CrudController

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
    model_class.where(person_id: params['person_id'])
  end

  private
  
  def person_id
    params['data']['relationships']['person']['data']['id']
  end

end
