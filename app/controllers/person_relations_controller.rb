# frozen_string_literal: true

class PersonRelationsController < CrudController
  def index
    redirect_to person_path(person_id)
  end

  def show
    redirect_to person_path(person_id)
  end

  def new
    params[model_identifier] = { person_id: person_id }
    super
  end

  def create
    super(location: person_path(person_id)) do |format, success|
      format.turbo_stream { render 'save_and_new' } if success && params.key?(:'save-and-new')
    end
  end

  def update
    super(location: person_path(person_id))
  end

  def destroy
    super(location: person_path(person_id)) do |format, success|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(entry) } if success
    end
  end

  def person_id
    params[:person_id] || model_params[:person_id]
  end
end
