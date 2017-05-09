require 'rails_helper'

describe AdvancedTraining do
  fixtures :advanced_trainings

  context 'validations' do
    it 'checks whether required attribute values are present' do
      advanced_training = AdvancedTraining.new
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(advanced_training.errors[:year_to].first).to eq('muss ausgefüllt werden')
      expect(advanced_training.errors[:person_id].first).to eq('muss ausgefüllt werden')
    end

    it 'should not be more than 1000 characters in the description' do
      advanced_training = advanced_trainings(:course)
      advanced_training.description = SecureRandom.hex(1000)
      advanced_training.valid?
      expect(advanced_training.errors[:description].first).to eq(
        'ist zu lang (mehr als 1000 Zeichen)'
      )
    end

    it 'does not create AdvancedTraining if year_from is later than year_to' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_to = 1997
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end
  end
end
