class SendUpdateProfileReminderMailJob < CronJob
  self.cron_expression = '0 3 * * 0'

  def perform
    people_to_remind.each do |person|
      ReminderMailer.update_user_reminder_email(person).deliver_later
    end
  end

  private

  def people_to_remind
    six_months_query.or(one_year_query)
  end

  def six_months_query
    base_query.where(people: { updated_at: ..12.months.ago })
  end

  def one_year_query
    base_query.where(people: { updated_at: ..12.months.ago })
  end

  def base_query
    Person
      .joins(:company)
      .where(reminder_mails_active: true)
      .where(companies: { reminder_mails_active: true })
  end
end
