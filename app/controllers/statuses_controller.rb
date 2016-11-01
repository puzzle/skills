class StatusesController < CrudController
  self.permitted_attrs = [:status]
end
