# frozen_string_literal: true

# A generic controller to display, create, update and destroy entries of a certain model class.
class Api::CrudController < Api::ListController
  class_attribute :permitted_attrs, :nested_models, :permitted_relationships

  # GET /users/1
  def show(options = {})
    render_entry({ include: '*' }.merge(options[:render_options] || {}))
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
      head :no_content
    else
      render_errors
    end
  end

  private

  def entry
    instance_variable_get(:"@#{ivar_name}") ||
      instance_variable_set(:"@#{ivar_name}", fetch_entry)
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
    render json: entry, status: :unprocessable_content,
           adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def entry_url
    send("#{self.class.name.underscore
         .gsub(/_controller$/, '')
         .gsub('/', '_').singularize}_url", entry)
  end

  # Only allow a trusted parameter "white list" through.
  def model_params
    attrs = params[:data][:attributes].permit(permitted_attrs)
    attrs = map_relationships(attrs)
    AttributeDeserializer.new(attrs, nested_models: nested_models).run
  end

  def map_relationships(attrs)
    relationships = params[:data][:relationships]

    return attrs if relationships.blank?

    relationships.each do |model_name, data|
      attrs[relationship_param_name(model_name)] = relationship_ids(data, model_name)
    end
    attrs
  end

  def relationship_param_name(model_name)
    permitted_param?("#{model_name}_id") ? "#{model_name}_id" : "#{model_name.singularize}_ids"
  end

  def relationship_ids(model_data, name)
    return unless model_data[:data]
    return model_data[:data][:id] unless model_data[:data].is_a?(Array)

    if permitted_relationship?(name)
      model_data[:data].pluck(:id)
    end
  end

  def permitted_param?(attribute_name)
    permitted_attrs.map(&:to_s).include?(attribute_name)
  end

  def permitted_relationship?(attribute_name)
    permitted_relationships.map(&:to_s).include?(attribute_name)
  end

  def ivar_name
    model_class.model_name.param_key
  end

  def get_asset_path(filename)
    manifest_file = Rails.application.assets_manifest.assets[filename]
    if manifest_file
      File.join(Rails.application.assets_manifest.directory, manifest_file)
    else
      Rails.application.assets&.[](filename)&.filename
    end
  end
end
