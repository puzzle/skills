# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [{ people_skills_attributes: [:id, :certificate, :level,
                                                       :interest, :core_competence, :_destroy] }]
  before_action :set_person

  def self.model_class
    Person
  end

  def update
    if params[:person].blank?
      render(:index, status: :ok)
    else
      super
    end
  end

  def show_path
    person_people_skills_path(@person)
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end
end
