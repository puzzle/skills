# frozen_string_literal: true

class PersonRelationsController < CrudController
  def create
    super(:location => person_path(person))
  end

  def update
    super(:location => person_path(person))
  end

  def destroy
    super(:location => person_path(person))
  end

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
