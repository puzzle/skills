class CompaniesController < CrudController
  self.permitted_attrs = %i[name web email phone
                            partnermanager contact_person email_contact_person
                            phone_contact_person crm level company_type offer_comment]
  self.nested_models = %i[locations employee_quantities people offers]

  def fetch_entries
    super.includes(:people,
                   :locations,
                   :offers,
                   :employee_quantities)
  end
end
