require 'rails_helper'

describe Education do
  fixtures :educations

  context 'validations' do
    it 'presence true' do
      education = Education.new
      education.valid?

      expect(education.errors[:year_from].first).to eq("can't be blank")
      expect(education.errors[:year_to].first).to eq("can't be blank")
      expect(education.errors[:person_id].first).to eq("can't be blank")
      expect(education.errors[:title].first).to eq("can't be blank")
      expect(education.errors[:location].first).to eq("can't be blank")
    end

    it 'max length should be 30' do
      education = educations(:bsc)
      education.updated_by = SecureRandom.hex(30)
      education.location = SecureRandom.hex(30)
      education.title = SecureRandom.hex(30)
      education.valid?

      expect(education.errors[:updated_by].first).to eq('is too long (maximum is 30 characters)')
      expect(education.errors[:location].first).to eq('is too long (maximum is 30 characters)')
      expect(education.errors[:title].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'does not create Education if from is bigger than to' do
      education = educations(:bsc)
      education.year_to = 1997
      education.valid?

      expect(education.errors[:year_from].first).to eq('must be higher than year from')
    end
  end
end
