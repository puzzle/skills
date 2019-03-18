# == Schema Information
#
# Table name: people_skills
#
#  id              :bigint(8)        not null, primary key
#  person_id       :bigint(8)
#  skill_id        :bigint(8)
#  level           :integer
#  interest        :integer
#  certificate     :boolean          default(FALSE)
#  core_competence :boolean          default(FALSE)
#

require 'rails_helper'

describe PeopleSkill do

  context 'validations' do
    it 'checks whether required attribute values are present' do
      people_skill = PeopleSkill.new
      people_skill.valid?

      expect(people_skill.errors[:person].first).to eq('muss ausgefüllt werden')
      expect(people_skill.errors[:skill].first).to eq('muss ausgefüllt werden')
      expect(people_skill.errors[:person].first).to eq('muss ausgefüllt werden')
      expect(people_skill.errors[:skill].first).to eq('muss ausgefüllt werden')
      expect(people_skill.errors[:core_competence].first).to eq('muss ausgefüllt werden')
      expect(people_skill.errors[:certificate].first).to eq('muss ausgefüllt werden')
    end
    
    it 'checks whether level is between 1 and 5' do
      people_skill = PeopleSkill.new
      people_skill.certificate = true
      people_skill.core_competence = false
      people_skill.level = 6
      people_skill.valid?

      expect(people_skill.errors[:level].first).to eq('muss kleiner oder gleich 5 sein')
      people_skill.level = -1
      people_skill.valid?
      expect(people_skill.errors[:level].first).to eq('muss größer oder gleich 0 sein')
    end

    it 'checks whether interest is between 1 and 5' do
      people_skill = PeopleSkill.new
      people_skill.certificate = true
      people_skill.core_competence = false
      people_skill.interest = 6
      people_skill.valid?

      expect(people_skill.errors[:interest].first).to eq('muss kleiner oder gleich 5 sein')
      people_skill.interest = -1
      people_skill.valid?
      expect(people_skill.errors[:interest].first).to eq('muss größer oder gleich 0 sein')
    end
  end
end
