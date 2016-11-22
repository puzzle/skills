require 'rails_helper'

describe Status do
  fixtures :statuses

  context 'validations' do
    it 'presence true' do
      status = Status.new
      status.valid?

      expect(status.errors[:status].first).to eq("can't be blank")
    end

    it 'description max length should be 30' do
      status = statuses(:employee)
      status.status = SecureRandom.hex(30)
      status.valid?
      expect(status.errors[:status].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'does not create Activity if from is bigger than to' do
      #activity = activities(:one)
      #activity.year_to = 2016
      #activity.valid?
      #expect(activity.errors[:year_to].first).to eq('must be higher than year from')
    end
  end
end
