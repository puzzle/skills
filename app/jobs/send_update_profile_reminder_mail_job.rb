class SendUpdateProfileReminderMailJob < CronJob
  self.cron_expression = '0 3 * * 7'

  def perform
    Person.find_each do |person|
      company = Company.find(person.company_id)
      if person.reminder_mails_active && company.reminder_mails_active && needs_reminder?(person)
        ReminderMailer.update_user_reminder_email(person).deliver_later
      end
    end
  end

  private

  def needs_reminder?(person)
    person.updated_at < 1.year.ago ||
    person.people_skills.exists?(['updated_at < ?', 1.year.ago])
  end
end
