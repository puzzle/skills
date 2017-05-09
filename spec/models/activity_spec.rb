require 'rails_helper'

describe Activity do
  fixtures :activities

  context 'validations' do
    it 'checks whether required attribute values are present' do
      activity = Activity.new
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:year_to].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:person_id].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:role].first).to eq('muss ausgefüllt werden')
    end

    it 'should not be more than 1000 characters in the description' do
      activity = activities(:ascom)
      activity.description = SecureRandom.hex(1000)
      activity.valid?
      expect(activity.errors[:description].first).to eq('ist zu lang (mehr als 1000 Zeichen)')
    end

    it 'does not create Activity if year_from is later than year_to' do
      activity = activities(:ascom)
      activity.year_to = 1997
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end
  end
end
