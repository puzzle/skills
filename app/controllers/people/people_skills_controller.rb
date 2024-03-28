# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [:level, :interest, :certificate, :core_competence]

  def index
    @person = Person.find(params[:id])
    super
  end

end
