# frozen_string_literal: true

class PersonRelationsController < CrudController

  def index
    redirect_to person_path(entry.person)
  end

  def show
    redirect_to person_path(entry.person)
  end

  def create
    super(render_on_unsaved: 'people/date_range_entities/new') do |format, success|
      if success && params.key?(:render_new_after_save)
        format.turbo_stream do
          render('people/date_range_entities/save_and_new',
                 locals: { attr_name: model_class.to_s.underscore.pluralize })
        end
      end
    end
  end

  def update
    super(location: person_path(entry.person), render_on_unsaved: 'people/date_range_entities/edit')
  end

  def destroy
    super do |format, success|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(entry) } if success
    end
  end
end
