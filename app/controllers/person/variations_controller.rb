class Person::VariationsController < CrudController
  self.permitted_attrs = PeopleController.permitted_attrs+ [:variation_name]

  self.nested_models = PeopleController.nested_models

  def index
    super(render_options: { include: [:status] })
  end

  def create
    Person::Variation.create_variation(params['variation_name'], params['person_id'])
  end

  class << self
    def model_class
      @model_class ||= 'Person::Variation'.classify.constantize
    end

    def model_serializer
      @model_serializer ||= 'VariationSerializer'.constantize
    end
  end
end
