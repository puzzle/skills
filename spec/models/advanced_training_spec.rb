require 'rails_helper'

describe AdvancedTraining do
  fixtures :advanced_trainings

  context 'validations' do
    it 'checks whether presence is true' do
      advanced_training = AdvancedTraining.new
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq("can't be blank")
      expect(advanced_training.errors[:year_to].first).to eq("can't be blank")
      expect(advanced_training.errors[:person_id].first).to eq("can't be blank")
    end

    it 'description max length should be 1000' do
      advanced_training = advanced_trainings(:course)
      advanced_training.description = SecureRandom.hex(1000)
      advanced_training.valid?
      expect(advanced_training.errors[:description].first).to eq('is too long (maximum is 1000 characters)')
    end


    it 'description max length should be 30' do
      advanced_training = advanced_trainings(:course)
      advanced_training.updated_by = SecureRandom.hex(30)
      advanced_training.valid?
      expect(advanced_training.errors[:updated_by].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'does not create AdvancedTraining if from is bigger than to' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_to = 1997
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('must be higher than year from')
    end
  end
end
