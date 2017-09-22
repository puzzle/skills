# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  year_from   :integer
#  year_to     :integer
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe AdvancedTraining do
  fixtures :advanced_trainings

  context 'validations' do
    it 'checks whether required attribute values are present' do
      advanced_training = AdvancedTraining.new
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss ausgefüllt werden')
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

    it 'does not create AdvancedTraining if year_from is later than year_to' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_to = 1997
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end

    it 'year should not be longer or shorter then 4' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_from = 12345
      advanced_training.year_to = 12345
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
      expect(advanced_training.errors[:year_to].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
    end

    it 'year_to can be blank' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_to = nil

      advanced_training.valid?

      expect(advanced_training.errors[:year_to]).to be_empty
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      AdvancedTraining.create(description: 'test1', year_from: '2000', person_id: bob_id)
      AdvancedTraining.create(description: 'test2', year_from: '2000', year_to: '2030', person_id: bob_id)

      list = AdvancedTraining.all.list

      expect(list.first.description).to eq('test1')
      expect(list.second.description).to eq('was nice')
      expect(list.third.description).to eq('course about how to clean')
      expect(list.fourth.description).to eq('test2')
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
