class SendUpdateProfileReminderMailJob < ApplicationJob
  queue_as :default
  def perform
    # return unless // admin view switch is off

    Person.find_each do |person|
      # only if user has not disabled it

      if needs_profile_reminder?(person)
        ReminderMailer.update_user_reminder_email(person).deliver_later
      end
    end
  end

  private

  def needs_profile_reminder?(person)
    person.updated_at < 1.year.ago
  end
end
