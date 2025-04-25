class Admin::UpdatePeopleController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_admin

  def manual_sync
    update_failed_names = NightlyUpdatePeopleDataPtimeJob.perform_now(is_manual_sync: true)
    if update_failed_names.any?
      flash[:alert] = t('.failed_people_updates', names: update_failed_names.to_sentence)
    else
      flash[:notice] = t('.people_updated')
    end
  end
end
