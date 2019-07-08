class SynchronizeJob < ApplicationRecord
  def update_last_runned_at
    update!(last_runned_at: DateTime.now)
  end
end
