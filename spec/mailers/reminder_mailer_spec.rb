require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  describe "notify" do
    let(:person) {people(:bob)}
    let(:mail) { ReminderMailer.update_user_reminder_email(person) }

    it "renders the headers" do
      expect(mail.subject).to eq("Erneuere dein Skills Profil!")
      expect(mail.to).to eq([person.email])
      expect(mail.from).to eq(["skills@puzzle.ch"])
    end
  end
end
