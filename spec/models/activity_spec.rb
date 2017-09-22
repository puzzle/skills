# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

require 'rails_helper'

describe Activity do
  fixtures :activities

  context 'validations' do
    it 'checks whether required attribute values are present' do
      activity = Activity.new
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(activity.errors[:person_id].first).to eq('muss ausgefüllt werden')
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

    it 'does not create Activity if year_from is later than year_to' do
      activity = activities(:ascom)
      activity.year_to = 1997
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end

    it 'year should not be longer or shorter then 4' do
      activity = activities(:ascom)
      activity.year_from = 12345
      activity.year_to = 12345
      activity.valid?

      expect(activity.errors[:year_from].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
      expect(activity.errors[:year_to].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
    end

    it 'year_to can be blank' do
      activity = activities(:ascom)
      activity.year_to = nil

      activity.valid?

      expect(activity.errors[:year_to]).to be_empty
    end

    it 'orders activties correctly with list scope' do
      bob_id = people(:bob).id
      Activity.create(description: 'test1', role: 'test', year_from: '2000', person_id: bob_id)
      Activity.create(description: 'test2', role: 'test', year_from: '2000', year_to: '2030', person_id: bob_id)

      list = Activity.all.list

      expect(list.first.description).to eq('test1')
      expect(list.second.description).to eq('Ascom')
      expect(list.third.description).to eq('test2')
      expect(list.fourth.description).to eq('Swisscom')
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
