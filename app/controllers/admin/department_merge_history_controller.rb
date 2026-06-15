class Admin::DepartmentMergeHistoryController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_admin
end
