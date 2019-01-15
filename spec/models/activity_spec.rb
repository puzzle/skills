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
#  finish_at   :date
#  start_at    :date
#

require 'rails_helper'

describe Activity do
  fixtures :activities

  context 'validations' do
    it 'checks whether required attribute values are present' do
      activity = Activity.new
      activity.valid?

      expect(activity.errors[:start_at].first).to eq('muss ausgefüllt werden')
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

    it 'does not create Activity if start_at is later than finish_at' do
      activity = activities(:ascom)
      activity.start_at = '2016-01-01'
      activity.valid?

      expect(activity.errors[:start_at].first).to eq('muss vor "Datum bis" sein')
    end

    it 'finish_at can be blank' do
      activity = activities(:ascom)
      activity.finish_at = nil

      activity.valid?

      expect(activity.errors[:finish_at]).to be_empty
    end

    it 'orders activties correctly with list scope' do
      bob_id = people(:bob).id
      Activity.create(description: 'test1', role: 'test', start_at: '2002-01-01', person_id: bob_id)
      Activity.create(description: 'test2', role: 'test', start_at: '2001-01-01', finish_at: '2030-01-01', person_id: bob_id)
      Activity.create(description: 'test3', role: 'test', start_at: '2001-01-01', finish_at: '2030-01-13', person_id: bob_id)
      Activity.create(description: 'test4', role: 'test', start_at: '2001-01-13', finish_at: '2030-01-01', person_id: bob_id)

      list = Activity.all.list

      expect(list[0].description).to eq('test1')
      expect(list[1].description).to eq('test2')
      expect(list[2].description).to eq('test4')
      expect(list[3].description).to eq('test3')
      expect(list[4].description).to eq('Ascom')
      expect(list[5].description).to eq('Swisscom')
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
