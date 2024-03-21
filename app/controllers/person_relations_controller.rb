# frozen_string_literal: true

class PersonRelationsController < CrudController
  private

  def entry
    relation = super
    relation.person = person
    relation
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
