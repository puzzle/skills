require 'rails_helper'

describe Education do
  fixtures :educations

  context 'validations' do
    it 'checks whether required attribute values are present' do
      education = Education.new
      education.valid?

      expect(education.errors[:year_from].first).to eq("can't be blank")
      expect(education.errors[:year_to].first).to eq("can't be blank")
      expect(education.errors[:person_id].first).to eq("can't be blank")
      expect(education.errors[:title].first).to eq("can't be blank")
      expect(education.errors[:location].first).to eq("can't be blank")
    end

    it 'should not be more than 50 characters' do
      education = educations(:bsc)
      education.location = SecureRandom.hex(50)
      education.title = SecureRandom.hex(50)
      education.valid?

      expect(education.errors[:location].first).to eq('is too long (maximum is 50 characters)')
      expect(education.errors[:title].first).to eq('is too long (maximum is 50 characters)')
    end

    it 'does not create Education if year_from is later than year_to' do
      education = educations(:bsc)
      education.year_to = 1997
      education.valid?

      expect(education.errors[:year_from].first).to eq('must be before year to')
    end
  end
end
