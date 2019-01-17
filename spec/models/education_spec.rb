# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  title      :text
#  updated_at :datetime
#  updated_by :string
#  person_id  :integer
#  finish_at  :date
#  start_at   :date
#

require 'rails_helper'

describe Education do
  fixtures :educations

  context 'validations' do
    it 'checks whether required attribute values are present' do
      education = Education.new
      education.valid?

      expect(education.errors[:start_at].first).to eq('muss ausgefüllt werden')
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

    it 'finish_at can be blank' do
      education = educations(:bsc)
      education.finish_at = nil

      education.valid?

      expect(education.errors[:finish_at]).to be_empty
    end

    it 'does not create Education if start_at is later than finish_at' do
      education = educations(:bsc)
      education.start_at = '2016-01-01'
      education.valid?

      expect(education.errors[:start_at].first).to eq('muss vor "Datum bis" sein')
    end

    it 'orders education correctly with list scope' do
      bob_id = people(:bob).id
      Education.create(title: 'test1', location: 'test1', start_at: '2012-01-01', person_id: bob_id)
      Education.create(title: 'test2', location: 'test2', start_at: '2005-01-01', finish_at: '2030-01-13', person_id: bob_id)
      Education.create(title: 'test3', location: 'test3', start_at: '2005-01-01', finish_at: '2030-01-01', person_id: bob_id)
      Education.create(title: 'test4', location: 'test4', start_at: '2004-01-01', finish_at: '2030-01-01', person_id: bob_id)

      list = Education.all.list

      expect(list[0].location).to eq('test1')
      expect(list[1].location).to eq('test3')
      expect(list[2].location).to eq('test4')
      expect(list[3].location).to eq('test2')
      expect(list[4].location).to eq('University of London')
      expect(list[5].location).to eq('Uni Bern')
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
