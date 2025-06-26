class ReminderMailer < ApplicationMailer
  def update_user_reminder_email(person)
    mail(to: person.email, subject: "Time to update your profile!")
  end
end
