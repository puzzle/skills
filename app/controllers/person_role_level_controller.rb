# frozen_string_literal: true

class PersonRoleLevelController < CrudController
  self.permitted_attrs = %i[level]
end
