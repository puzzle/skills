class Admin::CompaniesController < CrudController
  self.nesting = :admin
  self.permitted_attrs = %i[name]
end
