# frozen_string_literal: true

class PersonRelationsController < CrudController
  before_action :set_path
  def index
    redirect_to person_path(entry.person)
  end

  def show
    redirect_to person_path(entry.person)
  end

  def create
    super do |format, success|
      if success && params.key?(:render_new_after_save)
        remove_instance_variable(model_ivar_name)
        format.turbo_stream do
          render('save_and_new')
        end
      end
    end
  end

  def update
    super(location: person_path(entry.person))
  end

  def destroy
    super do |format, success|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(entry) } if success
    end
  end

  def set_path
    prepend_view_path 'app/views/people'
  end
end
