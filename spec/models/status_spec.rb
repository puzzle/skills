require 'rails_helper'

describe Status do
  fixtures :statuses

  context 'validations' do
    it 'checks whether presence is true' do
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
  end
end
