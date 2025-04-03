# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

require 'rails_helper'

describe Activity do
  fixtures :activities

  context 'validations' do
    it 'checks whether required attribute values are present' do
      activity = Activity.new
      activity.valid?
      expect(activity.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:person].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:role].first).to eq('muss ausgefüllt werden')
    end

    it 'checks validation maximum length for attribute' do
      activity = activities(:ascom)
      activity.description = SecureRandom.hex(5000)
      activity.role = SecureRandom.hex(500)

      activity.valid?

      expect(activity.errors[:description].first).to eq('ist zu lang (mehr als 5000 Zeichen)')
      expect(activity.errors[:role].first).to eq('ist zu lang (mehr als 500 Zeichen)')
    end

    it 'does not create Activity if start_at is later than finish_at' do
      activity = activities(:ascom)
      activity.year_from = 2016
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('muss vor dem Enddatum sein.')
    end

    it 'year_to can be blank' do
      activity = activities(:ascom)
      activity.year_to = nil

      activity.valid?

      expect(activity.errors[:year_to]).to be_empty
    end

    it 'orders activties correctly with list scope' do
      bob_id = people(:bob).id
      Activity.create(description: 'test1', role: 'test', year_from: 2002, month_from: 1, person_id: bob_id)
      Activity.create(description: 'test2', role: 'test', year_from: 2001, month_from: 1, year_to: 2030, month_to: 1, person_id: bob_id)
      Activity.create(description: 'test3', role: 'test', year_from: 2001, month_from: 1, year_to: 2030, month_to: nil, person_id: bob_id)
      Activity.create(description: 'test4', role: 'test', year_from: 2001, month_from: nil, year_to: 2030, month_to: 1, person_id: bob_id)

      list = Activity.all.list
      expect(list[0].description).to eq('test1')
      expect(list[1].description).to eq('test2')
      expect(list[2].description).to eq('test4')
      expect(list[3].description).to eq('test3')
      expect(list[4].description).to eq('SBB')
      expect(list[5].description).to eq('Migros')
      expect(list[6].description).to eq('Ascom')
      expect(list[7].description).to eq('Roche')
      expect(list[8].description).to eq('UBS')
      expect(list[9].description).to eq('Swisscom')
      expect(list[10].description).to eq('Novartis')
    end
  end

  context 'update' do
    it 'updates updated_at on person' do
      swisscom = activities(:swisscom)
      person_updated_at = swisscom.person.updated_at
      swisscom.description = 'UX Consultant - renewing their GUIs'
      swisscom.save!
      expect(swisscom.person.reload.updated_at).to be > person_updated_at
    end
  end
end
