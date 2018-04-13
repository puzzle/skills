class OffersController < CompanyRelationsController
  self.permitted_attrs = %i[category offer company_id]
end
