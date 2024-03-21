# frozen_string_literal: true

class PersonRelationsController < CrudController

  def fetch_entries
    model_class.where(person_id: params[:person_id])
  end

  private

  def entry
    instance_variable_set(:@person, Person.find(params[:person_id]))
    super
  end
end
