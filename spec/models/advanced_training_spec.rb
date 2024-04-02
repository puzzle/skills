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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

require 'rails_helper'

describe AdvancedTraining do
  fixtures :advanced_trainings

  context 'validations' do
    it 'checks whether required attribute values are present' do
      advanced_training = AdvancedTraining.new
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(advanced_training.errors[:person].first).to eq('muss ausgefüllt werden')
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
      advanced_training.year_from = 2016
      advanced_training.valid?

      expect(advanced_training.errors[:year_from].first).to eq('muss vor "Datum bis" sein')
    end

    it 'year_to can be blank' do
      advanced_training = advanced_trainings(:course)
      advanced_training.year_to = nil

      advanced_training.valid?

      expect(advanced_training.errors[:year_to]).to be_empty
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      AdvancedTraining.create(description: 'test1', year_from: 2000, month_from: 1, person_id: bob_id)
      AdvancedTraining.create(description: 'test2', year_from: 2016, month_from: 1, year_to: 2030, month_to: 1, person_id: bob_id)
      AdvancedTraining.create(description: 'test3', year_from: 2016, month_from: nil, year_to: 2030, month_to: nil, person_id: bob_id)
      AdvancedTraining.create(description: 'test4', year_from: 2016, month_from: 1, year_to: 2030, month_to: nil, person_id: bob_id)
      AdvancedTraining.create(description: 'test5', year_from: 2016, month_from: nil, year_to: 2030, month_to: 1, person_id: bob_id)

      list = AdvancedTraining.all.list

      expect(list[0].description).to eq('test1')
      expect(list[1].description).to eq('test2')
      expect(list[2].description).to eq('test3')
      expect(list[3].description).to eq('test4')
      expect(list[4].description).to eq('was nice')
      expect(list[5].description).to eq('course about how to clean')
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
