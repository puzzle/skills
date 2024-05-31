# frozen_string_literal: true

class Admin::DepartmentsController < CrudController
  self.nesting = :admin

  self.permitted_attrs = [:name]
end
