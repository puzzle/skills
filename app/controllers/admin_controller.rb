class AdminController < CrudController
  before_action :render_unauthorized_not_conf_admin
  before_action :set_company, only: [:index, :toggle_reminder_mails]

  def model_class
    AuthUser
  end

  def toggle_reminder_mails
    @company.update(company_params) ? head(:ok) : head(:unprocessable_entity)
  end

  private

  def set_company
    person_id = Person.find_by(name: current_auth_user&.name).id
    @company = Company.find(Person.find(person_id).company_id)
  end

  def company_params
    params.require(:company).permit(:reminder_mails_active)
  end
end