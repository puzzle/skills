# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finish_at   :date
#  start_at    :date
#

require 'rails_helper'

describe AdvancedTraining do
  fixtures :advanced_trainings

  context 'validations' do
    it 'checks whether required attribute values are present' do
      advanced_training = AdvancedTraining.new
      advanced_training.valid?

      expect(advanced_training.errors[:start_at].first).to eq('muss ausgefüllt werden')
      expect(advanced_training.errors[:person_id].first).to eq('muss ausgefüllt werden')
    end

    it 'checks validation maximum length for attribute' do
      advanced_training = advanced_trainings(:course)
      advanced_training.description = SecureRandom.hex(5000)
      advanced_training.valid?
      expect(advanced_training.errors[:description].first).to eq(
        'ist zu lang (mehr als 5000 Zeichen)'
      )
    end

    it 'does not create AdvancedTraining if start_at is later than finish_at' do
      advanced_training = advanced_trainings(:course)
      advanced_training.start_at = '2016-01-01'
      advanced_training.valid?

      expect(advanced_training.errors[:start_at].first).to eq('muss vor "Datum bis" sein')
    end

    it 'finish_at can be blank' do
      advanced_training = advanced_trainings(:course)
      advanced_training.finish_at = nil

      advanced_training.valid?

      expect(advanced_training.errors[:finish_at]).to be_empty
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      AdvancedTraining.create(description: 'test1', start_at: '2000-01-01', person_id: bob_id)
      AdvancedTraining.create(description: 'test2', start_at: '2016-01-01', finish_at: '2030-01-01', person_id: bob_id)

      list = AdvancedTraining.all.list

      expect(list.first.description).to eq('test2')
      expect(list.second.description).to eq('was nice')
      expect(list.third.description).to eq('course about how to clean')
      expect(list.fourth.description).to eq('test1')
    end
  end

  context 'update' do
    it 'updates updated_at on person' do
      course = advanced_trainings(:course)
      person_updated_at = course.person.updated_at
      course.description = 'RxJS Workshop'
      course.save!
      expect(course.person.reload.updated_at).to be > person_updated_at
    end
  end
end
