class AdminController < CrudController
  before_action :render_unauthorized_not_admin

  def model_class
    AuthUser
  end
end
