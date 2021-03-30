# frozen_string_literal: true

class AttributeDeserializer

  def initialize(params, options = {})
    @params = params
    @options = options
  end

  def run
    if options.key?(:nested_models)
      process_nested_models(params, Array.wrap(options[:nested_models]))
    end
    params
  end

  private

  attr_reader :params, :options

  def process_nested_models(attrs, nested_models)
    nested_models.each do |model|
      if model.is_a?(Hash)
        process_models_hash(attrs, model)
      elsif attrs.key?(model.to_s)
        attrs["#{model}_attributes"] = attrs.delete(model.to_s)
      end
    end
  end

  def process_models_hash(attrs, model)
    model.each do |key, value|
      model_attrs = attrs.delete(key.to_s)
      next if model_attrs.blank?

      attrs["#{key}_attributes"] = model_attrs
      if model_attrs.is_a?(Array)
        model_attrs.each { |ma| process_nested_models(ma, Array.wrap(value)) }
      else
        process_nested_models(model_attrs, Array.wrap(value))
      end
    end
  end
end
