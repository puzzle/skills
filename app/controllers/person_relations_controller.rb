# frozen_string_literal: true

class PersonRelationsController < CrudController
  def index
    redirect_to person_path(entry.person)
  end

  def show
    redirect_to person_path(entry.person)
  end

  def new
    redirect_to person_path(entry.person)
  end

  def edit
    redirect_to person_path(entry.person)
  end

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
