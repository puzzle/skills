# frozen_string_literal: true

class PersonRelationsController < CrudController
  TEMPLATE_BASE_PATH = 'people/date_range_entities'

  def index
    redirect_to person_path(entry.person)
  end

  def show
    redirect_to person_path(entry.person)
  end

  def new
    render "#{TEMPLATE_BASE_PATH}/new"
  end

  def edit
    render "#{TEMPLATE_BASE_PATH}/edit"
  end

  def create
    super(render_on_unsaved: "#{TEMPLATE_BASE_PATH}/new") do |format, success|
      if success && params.key?(:render_new_after_save)
        remove_instance_variable(model_ivar_name)
        format.turbo_stream do
          render("#{TEMPLATE_BASE_PATH}/save_and_new")
        end
      end
    end
  end

  def update
    super(location: person_path(entry.person), render_on_unsaved: "#{TEMPLATE_BASE_PATH}/edit")
  end

  def destroy
    super do |format, success|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(entry) } if success
    end
  end
end
