class EnvironmentController < CrudController
  self.permitted_attrs = %i[sentryDsn]

  def fetch_entries
    model_scope.last
  end

end
