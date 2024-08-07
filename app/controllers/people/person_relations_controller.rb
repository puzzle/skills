# frozen_string_literal: true

class People::PersonRelationsController < CrudController
  self.nesting = Person

  def index
    redirect_to person_path(entry.person)
  end

  def show
    redirect_to person_path(entry.person)
  end

  def create
    super do |format, success|
      if success
        if params.key?(:render_new_after_save)
          remove_instance_variable(model_ivar_name)
          format.turbo_stream { render('save_and_new') }
        else
          format.turbo_stream { render('refresh_after_new') }
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
end
