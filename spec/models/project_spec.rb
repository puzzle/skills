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
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  year_from   :integer
#

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


    it 'does not create Project if year_from is later than year_to' do
      project = projects(:duckduckgo)
      project.year_to = 1997
      project.valid?

      expect(project.errors[:year_from].first).to eq('muss vor Jahr bis sein')
    end

    it 'year should not be longer or shorter then 4' do
      project = projects(:duckduckgo)
      project.year_from = 12345
      project.year_to = 12345
      project.valid?

      expect(project.errors[:year_from].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
      expect(project.errors[:year_to].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
    end

    it 'year_to can be blank' do
      project = projects(:duckduckgo)
      project.year_to = nil

      project.valid?

      expect(project.errors[:year_to]).to be_empty
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
