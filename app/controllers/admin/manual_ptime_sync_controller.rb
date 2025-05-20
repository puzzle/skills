class Admin::ManualPtimeSyncController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_admin
  before_action :redirect_admin_unless_use_ptime_sync

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def manual_sync
    begin
      update_failed_names = NightlyUpdatePeopleDataPtimeJob.perform_now(is_manual_sync: true)
    rescue PtimeExceptions::PtimeClientError
      flash.now[:alert] = t('.fetching_data_failed')
      return render :index, status: :internal_server_error
    end
    if update_failed_names.values.flatten.any?
      flash.now[:alert] =
        t('.failed_people_updates', names: helpers.update_failed_names_message(update_failed_names))
      return render :index, status: :internal_server_error
    end
    flash.now[:notice] = t('.people_updated')
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def redirect_admin_unless_use_ptime_sync
    redirect_to admin_index_path unless Skills.use_ptime_sync?
  end
end
