require 'rails_helper'

describe Project do
  fixtures :projects

  context 'validations' do
    it 'checks whether required attribute values are present' do
      project = Project.new
      project.valid?

      expect(project.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:person_id].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:role].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:title].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:technology].first).to eq('muss ausgefüllt werden')
    end

    it 'should not be more than 1000 characters in the description' do
      project = projects(:duckduckgo)
      project.description = SecureRandom.hex(1000)
      project.valid?
      expect(project.errors[:description].first).to eq('ist zu lang (mehr als 1000 Zeichen)')
    end

    it 'should not be more than 50 characters' do
      project = projects(:duckduckgo)
      project.role = SecureRandom.hex(50)
      project.title = SecureRandom.hex(50)
      project.valid?
      expect(project.errors[:role].first).to eq('ist zu lang (mehr als 50 Zeichen)')
      expect(project.errors[:title].first).to eq('ist zu lang (mehr als 50 Zeichen)')
    end

    it 'should not be more than 100 characters' do
      project = projects(:duckduckgo)
      project.technology = SecureRandom.hex(100)
      project.valid?
      expect(project.errors[:technology].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end

    it 'does not create Project if year_from is later than year_to' do
      project = projects(:duckduckgo)
      project.year_to = 1997
      project.valid?

      expect(project.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      Project.create(title: 'test1', role: 'test1', technology: 'test', year_from: '2000', person_id: bob_id)
      Project.create(title: 'test2', role: 'test2', technology: 'test', year_from: '2000', year_to: '2030', person_id: bob_id)

      list = Project.all.list

      expect(list.first.title).to eq('test1')
      expect(list.second.title).to eq('google')
      expect(list.third.title).to eq('duckduckgo')
      expect(list.fourth.title).to eq('test2')
    end
  end
end
