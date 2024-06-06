class Admin::DepartmentsController < CrudController
  self.nesting = :admin
  self.permitted_attrs = %i[name]
end
