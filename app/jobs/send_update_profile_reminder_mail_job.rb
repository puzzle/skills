class SendUpdateProfileReminderMailJob < CronJob
  self.cron_expression = '0 3 * * 7'

  def perform
    people_to_remind.each do |person|
      ReminderMailer.update_user_reminder_email(person).deliver_later
    end
  end

  private

  def people_to_remind
    base_query.where(updated_at: six_months_condition)
              .or(base_query.where(updated_at: one_year_condition))
  end

  def six_months_condition
    (6.months.ago - 7.days)..6.months.ago
  end

  def one_year_condition
    (1.year.ago - 7.days)..1.year.ago
  end

  def base_query
    Person
      .joins(:company)
      .where(reminder_mails_active: true)
      .where(companies: { reminder_mails_active: true })
  end
end
