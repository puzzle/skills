# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  updated_by  :string
#  description :text
#  title       :text
#  role        :text
#  technology  :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  finish_at   :date
#  start_at    :date
#

require 'rails_helper'

describe Project do
  fixtures :projects

  context 'validations' do
    it 'checks whether required attribute values are present' do
      project = Project.new
      project.valid?

      expect(project.errors[:start_at].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:person_id].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:role].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:title].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:technology].first).to eq(nil)
    end

    it 'checks validation maximum length for attributes' do
      project = projects(:duckduckgo)

      project.description = SecureRandom.hex(5000)
      project.role = SecureRandom.hex(5000)
      project.technology = SecureRandom.hex(5000)
      project.title = SecureRandom.hex(500)

      project.valid?

      expect(project.errors[:description].first).to eq('ist zu lang (mehr als 5000 Zeichen)')
      expect(project.errors[:role].first).to eq('ist zu lang (mehr als 5000 Zeichen)')
      expect(project.errors[:technology].first).to eq('ist zu lang (mehr als 5000 Zeichen)')
      expect(project.errors[:title].first).to eq('ist zu lang (mehr als 500 Zeichen)')
    end


    it 'does not create Project if start_at is later than finish_at' do
      project = projects(:duckduckgo)
      project.start_at = '2016-01-01'
      project.valid?

      expect(project.errors[:start_at].first).to eq('muss vor "Datum bis" sein')
    end

    it 'finish_at can be blank' do
      project = projects(:duckduckgo)
      project.finish_at = nil

      project.valid?

      expect(project.errors[:finish_at]).to be_empty
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      Project.create(title: 'test1', role: 'test1', technology: 'test', start_at: '2014-01-01', person_id: bob_id)
      Project.create(title: 'test2', role: 'test2', technology: 'test', start_at: '2000-01-01', finish_at: '2030-01-01', person_id: bob_id)
      Project.create(title: 'test3', role: 'test2', technology: 'test', start_at: '2000-01-01', finish_at: '2030-01-13', person_id: bob_id)
      Project.create(title: 'test4', role: 'test2', technology: 'test', start_at: '2000-01-13', finish_at: '2030-01-01', person_id: bob_id)

      list = Project.all.list

      expect(list[0].title).to eq('test1')
      expect(list[1].title).to eq('test2')
      expect(list[2].title).to eq('test4')
      expect(list[3].title).to eq('test3')
      expect(list[4].title).to eq('google')
      expect(list[5].title).to eq('duckduckgo')
    end
  end

  context 'update' do
    it 'updates updated_at on person' do
      duckduckgo = projects(:duckduckgo)
      person_updated_at = duckduckgo.person.updated_at
      duckduckgo.description = 'Search engine performance optimizations'
      duckduckgo.save!
      expect(duckduckgo.person.reload.updated_at).to be > person_updated_at
    end
  end
end
