class CompaniesController < CrudController
  self.permitted_attrs = %i[name web email phone
                            partnermanager contact_person email_contact_person
                            phone_contact_person crm level picture my_company]

  self.nested_models = %i[locations employee_quantities]

  before_action :set_company, only: [:show, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.all

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through
    def company_params
      params.require(:company).permit(:name, :web, :email, :phone, :partnermanager,
                                      :contact_person, :email_contact_person,
                                      :phone_contact_person, :crm, :level, :picture, :my_company)
    end
end
