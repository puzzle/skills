class AddReminderMailsActive < ActiveRecord::Migration[8.0]
  def change
    add_column :people_skills, :created_at, :datetime
    add_column :people_skills, :updated_at, :datetime
    add_column :companies, :reminder_mails_active, :boolean, default: false
    add_column :people, :reminder_mails_active, :boolean, default: true
  end
end
