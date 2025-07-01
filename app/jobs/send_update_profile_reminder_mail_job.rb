class SendUpdateProfileReminderMailJob < CronJob
  self.cron_expression = '0 3 * * 7'

  def perform
    Person.find_each do |person|
      company = Company.find(person.company_id)
      unless person.reminder_mails_active === false || company.reminder_mails_active === false
        if needs_profile_reminder?(person)
          ReminderMailer.update_user_reminder_email(person).deliver_later
        end
      end
    end
  end

  private

  def needs_profile_reminder?(person)
    person.updated_at < 1.year.ago ||
    person.people_skills.where('updated_at < ?', 1.year.ago).exists?
  end
end
