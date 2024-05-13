require 'rails_helper'

describe PeopleSkillsFilter do

  context 'filter' do
    it 'does not filter people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, '')
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(16)
      expect(levels).to eq([3, 1, 0, 1, 0, 1, 5, 4, 5, 5, 5, 5, 1, 1, 1, 1])
      expect(interests).to eq([5, 4, 0, 4, 0, 2, 4, 5, 3, 2, 2, 4, 5, 3, 2, 4])
    end

    it 'filters rated people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, true)
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(14)
      expect(levels).to eq([3, 1, 1, 1, 5, 4, 5, 5, 5, 5, 1, 1, 1, 1])
      expect(interests).to eq([5, 4, 4, 2, 4, 5, 3, 2, 2, 4, 5, 3, 2, 4])
    end

    it 'filters unrated people skills' do
      filter = PeopleSkillsFilter.new(PeopleSkill.all, false)
      filteredPeopleSkills = filter.scope
      levels = filteredPeopleSkills.pluck(:level)
      interests = filteredPeopleSkills.pluck(:interest)

      expect(filteredPeopleSkills.count).to eq(2)
      expect(levels).to eq([0, 0])
      expect(interests).to eq([0, 0])
    end
  end
end
