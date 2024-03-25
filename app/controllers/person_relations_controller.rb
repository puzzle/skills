# frozen_string_literal: true

class PersonRelationsController < CrudController
  skip_before_action :entry, only: :destroy

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
    relation.person = person unless person == relation.person
    relation
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
