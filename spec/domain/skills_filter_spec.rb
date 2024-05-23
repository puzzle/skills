require 'rails_helper'

describe SkillsFilter do

  context 'filter' do
    it 'does not filter skills' do
      filter = SkillsFilter.new(Skill.all, nil, nil, nil)
      filtered_skills = filter.scope

      expect(filtered_skills.count).to eq(5)
      expect(filtered_skills[0].title).to eq('Bash')
      expect(filtered_skills[1].title).to eq('cunit')
      expect(filtered_skills[2].title).to eq('ember')
      expect(filtered_skills[3].title).to eq('JUnit')
      expect(filtered_skills[4].title).to eq('Rails')
    end

    it 'filters skills by category' do
      filter = SkillsFilter.new(Skill.all, 458108788, nil, nil)
      filtered_skills = filter.scope.pluck(:title)
      expect(filtered_skills.count).to eq(4)
      expect(filtered_skills).to include('Rails')
      expect(filtered_skills).to include('JUnit')
      expect(filtered_skills).to include('cunit')
      expect(filtered_skills).to include('ember')
    end

    it 'filters skills by title' do
      filter = SkillsFilter.new(Skill.all, nil, 'Rails', nil)
      filtered_skills = filter.scope

      expect(filtered_skills.count).to eq(1)
      expect(filtered_skills[0].title).to eq('Rails')
    end

    it 'filters skills by default set' do
      filter = SkillsFilter.new(Skill.all, nil, nil, 'new')
      filtered_skills = filter.scope

      expect(filtered_skills.count).to eq(1)
      expect(filtered_skills[0].title).to eq('Bash')
    end

    it 'filters skills by category, default set and title' do
      filter = SkillsFilter.new(Skill.all, 458108788, 'u', 'false')
      filtered_skills = filter.scope

      expect(filtered_skills.count).to eq(2)
      expect(filtered_skills[0].title).to eq('cunit')
      expect(filtered_skills[1].title).to eq('JUnit')
    end
  end
end
