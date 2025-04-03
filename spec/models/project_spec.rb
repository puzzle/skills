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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

require 'rails_helper'

describe Project do
  fixtures :projects

  context 'validations' do
    it 'checks whether required attribute values are present' do
      project = Project.new
      project.valid?

      expect(project.errors[:year_from].first).to eq('muss ausgefüllt werden')
      expect(project.errors[:person].first).to eq('muss ausgefüllt werden')
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
      project.year_from = 2016
      project.valid?

      expect(project.errors[:year_from].first).to eq('muss vor dem Enddatum sein.')
    end

    it 'year_to can be blank' do
      project = projects(:duckduckgo)
      project.year_to = nil

      project.valid?

      expect(project.errors[:year_to]).to be_empty
    end

    it 'orders projects correctly with list scope' do
      bob_id = people(:bob).id
      Project.create(title: 'test1', role: 'test1', technology: 'test', year_from: 2014, month_from: 1, person_id: bob_id)
      Project.create(title: 'test2', role: 'test2', technology: 'test', year_from: 2000, month_from: 1, year_to: 2030, month_to: 1, person_id: bob_id)
      Project.create(title: 'test3', role: 'test2', technology: 'test', year_from: 2000, month_from: 1, year_to: 2030, month_to: nil, person_id: bob_id)
      Project.create(title: 'test4', role: 'test2', technology: 'test', year_from: 2000, month_from: nil, year_to: 2030, month_to: 1, person_id: bob_id)

      list = Project.all.list

      expect(list[0].title).to eq('test1')
      expect(list[1].title).to eq('test2')
      expect(list[2].title).to eq('test4')
      expect(list[3].title).to eq('test3')
      expect(list[4].title).to eq('cook')
      expect(list[5].title).to eq('fisherman')
      expect(list[6].title).to eq('system engineer')
      expect(list[7].title).to eq('it director')
      expect(list[8].title).to eq('google')
      expect(list[9].title).to eq('salesman')
      expect(list[10].title).to eq('duckduckgo')
      expect(list[11].title).to eq('community manager')
      expect(list[12].title).to eq('construction analyst')
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
