class AddReminderMailsActiveToCompanies < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:companies, :reminder_mails_active)
      add_column :companies, :reminder_mails_active, :boolean, default: false
    end
  end
end
