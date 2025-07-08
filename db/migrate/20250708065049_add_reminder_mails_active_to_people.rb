class AddReminderMailsActiveToPeople < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:people, :reminder_mails_active)
      add_column :people, :reminder_mails_active, :boolean, default: true
    end
  end
end
