class ReminderMailer < ApplicationMailer
  def update_user_reminder_email
    @user = user
    mail(to: @user.email, subject: "Time to update your profile!")
  end
end
