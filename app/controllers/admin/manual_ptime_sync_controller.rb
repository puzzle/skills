class Admin::ManualPtimeSyncController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_conf_admin
  before_action :redirect_admin, unless: -> { Skills.use_ptime_sync? }

  def manual_sync
    begin
      update_failed_names = NightlyUpdatePeopleDataPtimeJob.perform_now(is_manual_sync: true)
    rescue PtimeExceptions::PtimeClientError
      flash.now[:alert] = t('.fetching_data_failed')
      return render :index, status: :internal_server_error
    end
    return_update_status(update_failed_names)
  end

  private

  def return_update_status(update_failed_names)
    if update_failed_names.values.flatten.any?
      flash.now[:alert] =
        t('.manual_sync.failed_people_updates',
          names: helpers.update_failed_names_message(update_failed_names))
      return render :index, status: :internal_server_error
    end
    flash.now[:notice] = t('.manual_sync.people_updated')
  end

  def redirect_admin
    redirect_to admin_index_path
  end
end
