class LocationsController < CompanyRelationsController
  self.permitted_attrs = %i[location company_id]
end
