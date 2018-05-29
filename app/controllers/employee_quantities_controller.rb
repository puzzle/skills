class EmployeeQuantitiesController < CompanyRelationsController
  self.permitted_attrs = %i[category quantity company_id]
end