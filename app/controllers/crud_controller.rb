# A generic controller to display, create, update and destroy entries of a certain model class.
class CrudController < ListController
  class_attribute :permitted_attrs, :nested_models

  # GET /users/1
  def show(options = {})
    render_entry(options[:render_options])
  end

  # POST /users
  def create(options = {})
    build_entry
    if entry.save
      render_entry({ status: :created,
                     location: entry_url }
                   .merge(options[:render_options] || {}))
    else
      render_errors
    end
  end

  # PATCH/PUT /users/1
  def update(options = {})
    entry.attributes = model_params
    if entry.save
      render_entry(options[:render_options])
    else
      render_errors
    end
  end

  # DELETE /users/1
  def destroy(_options = {})
    if entry.destroy
      head 204
    else
      render_errors
    end
  end

  private

  def entry
    instance_variable_get(:"@#{ivar_name}") ||
      instance_variable_set(:"@#{ivar_name}", fetch_entry)
  end

  def person_id
    instance_variable_get(:@_params)['person_id']
  end

  def fetch_entry
    model_scope.find(params.fetch(:id))
  end

  def build_entry
    instance_variable_set(:"@#{ivar_name}", model_scope.new(model_params))
  end

  def render_entry(options = {})
    render({ json: entry,
             serializer: model_serializer,
             root: model_root_key }
           .merge(render_options)
           .merge(options || {}))
  end

  def render_errors
    render json: entry.errors.details, status: :unprocessable_entity
  end

  def entry_url
    send("#{self.class.name.underscore
         .gsub(/_controller$/, '')
         .gsub(/\//, '_').singularize}_url", entry, person_id)
  end

  # Only allow a trusted parameter "white list" through.
  def model_params
    attrs = params.require(model_identifier).permit(permitted_attrs)
    AttributeDeserializer.new(attrs, nested_models: nested_models).run
  end

  def ivar_name
    model_class.model_name.param_key
  end
end
