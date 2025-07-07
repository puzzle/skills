require 'rails_helper'

RSpec.describe SendUpdateProfileReminderMailJob, type: :job do
  describe 'when a person has not been updated for a year and all reminders are active' do
    let(:person) { people(:bob) }
    let(:company) { companies(:firma) }

    before do
      allow(Company).to receive(:find).with(person.company_id).and_return(company)
      allow(Person).to receive(:find_each).and_yield(person)
      person.update_column(:updated_at, 1.years.ago + 1.day)
    end

    it 'should send a reminder email' do
      mailer_double = double('ReminderMailer', deliver_later: true)
      expect(ReminderMailer).to receive(:update_user_reminder_email).with(person).and_return(mailer_double)

      SendUpdateProfileReminderMailJob.new.perform
    end
  end

  describe 'when a person has not been updated for 6 months and all reminders are active' do
    let(:person) { people(:bob) }
    let(:company) { companies(:firma) }

    before do
      allow(Company).to receive(:find).with(person.company_id).and_return(company)
      allow(Person).to receive(:find_each).and_yield(person)
      person.update_column(:updated_at, 6.months.ago + 1.day)
    end

    it 'should send a reminder email' do
      mailer_double = double('ReminderMailer', deliver_later: true)
      expect(ReminderMailer).to receive(:update_user_reminder_email).with(person).and_return(mailer_double)

      SendUpdateProfileReminderMailJob.new.perform
    end
  end

  describe 'when company reminders are inactive' do
    let(:person) { people(:bob) }
    let(:company) { companies(:partner) }

    before do
      allow(Company).to receive(:find).with(person.company_id).and_return(company)
      allow(Person).to receive(:find_each).and_yield(person)
      person.update_column(:updated_at, 2.years.ago)
    end

    it 'should send no reminder email' do
      expect(ReminderMailer).not_to receive(:update_user_reminder_email)

      SendUpdateProfileReminderMailJob.new.perform
    end
  end

  describe 'when the person is not outdated' do
    let(:person) { people(:bob) }
    let(:company) { companies(:firma) }

    before do
      allow(Company).to receive(:find).with(person.company_id).and_return(company)
      allow(Person).to receive(:find_each).and_yield(person)
      person.update_column(:updated_at, 2.month.ago)
    end

    it 'should send no reminder email' do
      expect(ReminderMailer).not_to receive(:update_user_reminder_email)

      SendUpdateProfileReminderMailJob.new.perform
    end
  end

  describe 'when person reminders are inactive' do
    let(:person) { people(:alice) }
    let(:company) { companies(:firma) }

    before do
      allow(Company).to receive(:find).with(person.company_id).and_return(company)
      allow(Person).to receive(:find_each).and_return(:person)
      person.update_column(:updated_at, 2.years.ago)
    end

    it 'should send no reminder email' do
      expect(ReminderMailer).not_to receive(:update_user_reminder_email)

      SendUpdateProfileReminderMailJob.new.perform
    end
  end
end
