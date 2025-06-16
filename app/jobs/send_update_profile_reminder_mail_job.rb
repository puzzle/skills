class SendUpdateProfileReminderMailJob < ApplicationJob
  queue_as :default

  def perform
    Person.find_each do |person|
      company = Company.find(id: person.company_id)
      unless person.reminder_mails_active === false || company.reminder_mails_active === false
        if needs_profile_reminder?(person)
          ReminderMailer.update_user_reminder_email(person).deliver_later
        end
      end
    end
  end

  private

  def needs_profile_reminder?(person)
    person.updated_at < 1.year.ago
  end
end
