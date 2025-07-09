class AddReminderMailsActiveToPeople < ActiveRecord::Migration[8.0]
  def change
      add_column :people, :reminder_mails_active, :boolean, default: true
  end
end
