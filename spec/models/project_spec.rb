require 'rails_helper'

describe Project do
  fixtures :projects

  context 'validations' do
    it 'checks whether presence is true' do

      project = Project.new
      project.valid?

      expect(project.errors[:year_from].first).to eq("can't be blank")
      expect(project.errors[:year_to].first).to eq("can't be blank")
      expect(project.errors[:person_id].first).to eq("can't be blank")
      expect(project.errors[:role].first).to eq("can't be blank")
      expect(project.errors[:title].first).to eq("can't be blank")
      expect(project.errors[:technology].first).to eq("can't be blank")
    end

    it 'description max length should be 1000' do
      project = projects(:duckduckgo)
      project.description = SecureRandom.hex(1000)
      project.valid?
      expect(project.errors[:description].first).to eq('is too long (maximum is 1000 characters)')
    end

    it 'description max length should be 30' do
      project = projects(:duckduckgo)
      project.updated_by = SecureRandom.hex(30)
      project.role = SecureRandom.hex(30)
      project.title = SecureRandom.hex(30)
      project.valid?
      expect(project.errors[:updated_by].first).to eq('is too long (maximum is 30 characters)')
      expect(project.errors[:role].first).to eq('is too long (maximum is 30 characters)')
      expect(project.errors[:title].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'description max length should be 100' do
      project = projects(:duckduckgo)
      project.technology = SecureRandom.hex(100)
      project.valid?
      expect(project.errors[:technology].first).to eq('is too long (maximum is 100 characters)')
    end

    it 'does not create Project if from is bigger than to' do
      project = projects(:duckduckgo)
      project.year_to = 1997
      project.valid?

      expect(project.errors[:year_from].first).to eq('must be higher than year from')
    end
  end
end
