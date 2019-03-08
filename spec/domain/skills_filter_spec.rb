require 'rails_helper'

describe SkillsFilter do

  context 'filter' do
    it 'does not filter skills' do
      filter = SkillsFilter.new(Skill.all, nil, nil, nil)
      filteredSkills = filter.scope

      expect(filteredSkills.count).to eq(3)
      expect(filteredSkills[0].title).to eq('Rails')
      expect(filteredSkills[1].title).to eq('JUnit')
      expect(filteredSkills[2].title).to eq('Bash')
    end

    it 'filters skills by category' do
      filter = SkillsFilter.new(Skill.all, 458108788, nil, nil)
      filteredSkills = filter.scope

      expect(filteredSkills.count).to eq(2)
      expect(filteredSkills[0].title).to eq('Rails')
      expect(filteredSkills[1].title).to eq('JUnit')
    end
    
    it 'filters skills by title' do
      filter = SkillsFilter.new(Skill.all, nil, 'Rails', nil)
      filteredSkills = filter.scope

      expect(filteredSkills.count).to eq(1)
      expect(filteredSkills[0].title).to eq('Rails')
    end
    
    it 'filters skills by default set' do
      filter = SkillsFilter.new(Skill.all, nil, nil, 'new')
      filteredSkills = filter.scope

      expect(filteredSkills.count).to eq(1)
      expect(filteredSkills[0].title).to eq('Bash')
    end
    
    it 'filters skills by category, default set and title' do
      filter = SkillsFilter.new(Skill.all, 458108788, 'u', 'false')
      filteredSkills = filter.scope

      expect(filteredSkills.count).to eq(1)
      expect(filteredSkills[0].title).to eq('JUnit')
    end
  end
end
