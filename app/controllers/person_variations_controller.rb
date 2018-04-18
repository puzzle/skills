class PersonVariationsController < CrudController
  self.permitted_attrs = PeopleController.permitted_attrs + %i[variation_name person_id]

  self.nested_models = PeopleController.nested_models

  def index
    person_variations = fetch_entries
    render json: person_variations, each_serializer: PersonVariationsSerializer
  end

  def create
    variation = Person::Variation.create_variation(params['variation_name'], params['person_id'])
    if variation.persisted?
      render(json: variation, serializer: PersonVariationsSerializer)
    else
      render json: variation.errors.details, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: e.message, status: :unprocessable_entity
  end

  protected

  def fetch_entries
    model_class.where(origin_person_id: params['person_id'])
  end

  class << self
    def model_class
      @model_class ||= Person::Variation
    end

    def model_serializer
      @model_serializer ||= VariationSerializer
    end
  end
end
