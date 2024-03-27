# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [:level, :interest, :certificate, :core_competence]

end
