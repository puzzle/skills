class SendUpdateProfileReminderMailJob < CronJob
  self.cron_expression = '0 3 * * 7'

  def perform
    find_people_to_remind.find_each do |person|
      ReminderMailer.update_user_reminder_email(person).deliver_later
    end
  end

  private

  def find_people_to_remind
    Person
      .joins(:company)
      .where(reminder_mails_active: true)
      .where(companies: { reminder_mails_active: true })
      .where(
        updated_at: six_months_condition
      ).or(Person.where(updated_at: one_year_condition))
  end

  def six_months_condition
    6.months.ago..6.months.ago + 7.days
  end

  def one_year_condition
    1.year.ago..1.year.ago + 7.days
  end
end
