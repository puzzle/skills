require 'rails_helper'

describe Status do
  fixtures :statuses

  context 'validations' do
    it 'checks whether required attribute values are present' do
      status = Status.new
      status.valid?

      expect(status.errors[:status].first).to eq("can't be blank")
    end

    it 'should not be more than 30 characters' do
      status = statuses(:employee)
      status.status = SecureRandom.hex(30)
      status.valid?
      expect(status.errors[:status].first).to eq('is too long (maximum is 30 characters)')
    end
  end
end
