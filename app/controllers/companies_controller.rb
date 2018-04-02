class CompaniesController < CrudController
  self.permitted_attrs = %i[name web email phone
                            partnermanager contact_person email_contact_person
                            phone_contact_person crm level picture my_company]

  self.nested_models = %i[locations employee_quantities people]

  skip_before_action :authorize, only: :picture

  def index
    @companies = Company.all
    render json: @companies
  end

  def update_picture
    company.update(picture: params[:picture])
    render json: { data: { picture_path:company_picture_path(params[:company_id]) } }
  end
  
  def picture
    default_avatar_url = "#{Rails.public_path}/default_avatar.png"
    picture_url = company.picture.file.nil? ? default_avatar_url : company.picture.url
    send_file(picture_url, disposition: 'inline')
  end

  private

  def company
    @company ||= Company.find(params[:company_id])
  end
end
