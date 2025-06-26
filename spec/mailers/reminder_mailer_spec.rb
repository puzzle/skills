require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  describe "notify" do
    let(:person) {people(:bob)}
    let(:mail) { ReminderMailer.update_user_reminder_email(person) }

    it "renders the headers" do
      expect(mail.subject).to eq("Time to update your profile!")
      expect(mail.to).to eq([person.email])
      ## expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.parts.to_s).to match('[#<Mail::Part:26032, Multipart: false, Headers: <Content-Type: text/plain>>, #<Mail::Part:26040, Multipart: false, Headers: <Content-Type: text/html>>]')
    end
  end
end
