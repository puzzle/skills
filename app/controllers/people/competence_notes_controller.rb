# frozen_string_literal: true
class People::CompetenceNotesController < CrudController
  def update
    @person.update!(competence_notes: params[:competence_notes])
    render 'people/competence_notes/show'
  end

  def model_class
    Person
  end
end

