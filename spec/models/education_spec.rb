require 'rails_helper'

describe Education do
  fixtures :educations

  context 'validations' do
    it 'checks whether required attribute values are present' do
      education = Education.new
      education.valid?

      expect(education.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(education.errors[:person_id].first).to eq('muss ausgefüllt werden')
      expect(education.errors[:title].first).to eq('muss ausgefüllt werden')
      expect(education.errors[:location].first).to eq('muss ausgefüllt werden')
    end

    it 'should not be more than 50 characters' do
      education = educations(:bsc)
      education.location = SecureRandom.hex(50)
      education.title = SecureRandom.hex(50)
      education.valid?

      expect(education.errors[:location].first).to eq('ist zu lang (mehr als 50 Zeichen)')
      expect(education.errors[:title].first).to eq('ist zu lang (mehr als 50 Zeichen)')
    end

    it 'does not create Education if year_from is later than year_to' do
      education = educations(:bsc)
      education.year_to = 1997
      education.valid?

      expect(education.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end

    it 'orders education correctly with list scope' do
      bob_id = people(:bob).id
      Education.create(title: 'test1', location: 'test1', year_from: '2000', person_id: bob_id)
      Education.create(title: 'test2', location: 'test2', year_from: '2000', year_to: '2030', person_id: bob_id)

      list = Education.all.list

      expect(list.first.location).to eq('test1')
      expect(list.second.location).to eq('University of London')
      expect(list.third.location).to eq('test2')
      expect(list.fourth.location).to eq('Uni Bern')
    end
  end
end
