# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [ { people_skills_attributes: [:id, :certificate, :level,
                                                       :interest, :core_competence, :_destroy] }]

  def index
    @person = Person.find(params[:id])
    super
  end

  def edit
    @person = Person.find(params[:id])
    super
  end

  def self.model_class
    Person
  end

end
