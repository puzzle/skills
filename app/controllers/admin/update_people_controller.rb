class Admin::UpdatePeopleController < CrudController
  self.nesting = :admin
  self.permitted_attrs = %i[name]
  before_action :render_unauthorized_not_admin

  def manual_sync
    NightlyUpdatePeopleDataPtimeJob.perform_now
  end
end
