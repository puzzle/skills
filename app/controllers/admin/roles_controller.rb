class Admin::RolesController < CrudController
  self.nesting = :admin
  self.permitted_attrs = %i[name]
  before_action :render_unauthorized_not_conf_admin
end
