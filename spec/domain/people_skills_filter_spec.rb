require 'rails_helper'

describe PeopleSkillsFilter do

  context 'filter' do
    it 'does not filter people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, '')
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(3)
      expect(levels).to eq([3, 1, 0])
      expect(interests).to eq([5, 1, 0])
    end

    it 'filters rated people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, 'true')
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(2)
      expect(levels).to eq([3, 1])
      expect(interests).to eq([5, 1])
    end

    it 'it filters unrated people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, 'false')
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(1)
      expect(levels).to eq([0])
      expect(interests).to eq([0])
    end
  end
end
