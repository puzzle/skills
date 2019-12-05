# frozen_string_literal: true

class DepartmentsController < CrudController
  self.permitted_attrs = %i[name]
end
