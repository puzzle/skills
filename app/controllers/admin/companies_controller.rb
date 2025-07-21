class Admin::CompaniesController < CrudController
  self.nesting = :admin
  self.permitted_attrs = %i[name reminder_mails_active]
  before_action :render_unauthorized_not_conf_admin
end
