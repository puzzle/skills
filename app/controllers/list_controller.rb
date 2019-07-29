# frozen_string_literal: true

# A generic controller to display entries of a certain model class.
class ListController < ApplicationController
  delegate :model_class, :model_identifier, :model_serializer, :list_serializer,
           to: 'self.class'

  class_attribute :render_options
  self.render_options = {}

  # GET /users
  def index(options = {})
    render({ json: fetch_entries,
             each_serializer: list_serializer,
             root: model_root_key.pluralize }
           .merge(render_options)
           .merge(options.fetch(:render_options, {})))
  end

  protected

  def fetch_entries
    model_scope.list
  end

  private

  def model_scope
    model_class
  end

  def model_root_key
    model_class.name.underscore
  end

  class << self
    # The ActiveRecord class of the model.
    def model_class
      model_name = controller_path.classify.remove('::')
      @model_class ||= model_name.constantize
    end

    # The identifier of the model used for form parameters.
    # I.e., the symbol of the underscored model name.
    def model_identifier
      @model_identifier ||= model_class.model_name.param_key
    end

    def list_serializer
      model_serializer
    end

    def model_serializer
      @model_serializer ||= "#{model_class.name}Serializer".constantize
    end
  end
end
