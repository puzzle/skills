class ReminderMailer < ApplicationMailer
  def update_user_reminder_email(person)
    mail(to: person.email, subject: 'Erneuere dein Skills Profil!')
  end
end
