# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  title      :text
#  updated_at :datetime
#  updated_by :string
#  year_from  :integer
#  year_to    :integer
#  person_id  :integer
#

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

    it 'checks validation maximum length for attribute' do
      education = educations(:bsc)
      education.location = SecureRandom.hex(500)
      education.title = SecureRandom.hex(500)
      education.valid?

      expect(education.errors[:location].first).to eq('ist zu lang (mehr als 500 Zeichen)')
      expect(education.errors[:title].first).to eq('ist zu lang (mehr als 500 Zeichen)')
    end

    it 'year should not be longer or shorter then 4' do
      education = educations(:bsc)
      education.year_from = 12345
      education.year_to = 12345
      education.valid?

      expect(education.errors[:year_from].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
      expect(education.errors[:year_to].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
    end

    it 'year_to can be blank' do
      education = educations(:bsc)
      education.year_to = nil

      education.valid?

      expect(education.errors[:year_to]).to be_empty
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

  context 'update' do
    it 'updates updated_at on person' do
      bsc = educations(:bsc)
      person_updated_at = bsc.person.updated_at
      bsc.title = 'BSc in Machine Learning'
      bsc.save!
      expect(bsc.person.reload.updated_at).to be > person_updated_at
    end
  end
end
