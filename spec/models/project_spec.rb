require 'rails_helper'

describe Project do
  fixtures :projects

  context 'validations' do
    it 'checks whether required attribute values are present' do
      project = Project.new
      project.valid?

      expect(project.errors[:year_from].first).to eq("can't be blank")
      expect(project.errors[:year_to].first).to eq("can't be blank")
      expect(project.errors[:person_id].first).to eq("can't be blank")
      expect(project.errors[:role].first).to eq("can't be blank")
      expect(project.errors[:title].first).to eq("can't be blank")
      expect(project.errors[:technology].first).to eq("can't be blank")
    end

    it 'should not be more than 1000 characters in the description' do
      project = projects(:duckduckgo)
      project.description = SecureRandom.hex(1000)
      project.valid?
      expect(project.errors[:description].first).to eq('is too long (maximum is 1000 characters)')
    end

    it 'should not be more than 30 characters' do
      project = projects(:duckduckgo)
      project.role = SecureRandom.hex(30)
      project.title = SecureRandom.hex(30)
      project.valid?
      expect(project.errors[:role].first).to eq('is too long (maximum is 30 characters)')
      expect(project.errors[:title].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'should not be more than 100 characters' do
      project = projects(:duckduckgo)
      project.technology = SecureRandom.hex(100)
      project.valid?
      expect(project.errors[:technology].first).to eq('is too long (maximum is 100 characters)')
    end

    it 'does not create Project if year_from is later than year_to' do
      project = projects(:duckduckgo)
      project.year_to = 1997
      project.valid?

      expect(project.errors[:year_from].first).to eq('must be before year to')
    end
  end
end
